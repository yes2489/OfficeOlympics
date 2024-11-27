######################################## DDL ########################################

-- 기존에 같은 이름의 데이터베이스가 있다면 삭제합니다.
DROP DATABASE IF EXISTS olympic_db;

-- 새로운 데이터베이스를 생성하고, 문자셋을 utf8mb4로 설정합니다.
CREATE DATABASE olympic_db DEFAULT CHARACTER SET utf8mb4;

-- olympic_db 데이터베이스를 사용합니다.
USE olympic_db;

-- 사용자 정보를 저장하는 테이블 생성
CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY, -- 사용자 ID (자동 증가)
  email VARCHAR(255) NOT NULL UNIQUE, -- 로그인 ID로 사용할 이메일 (중복 불가)
  password VARCHAR(128) NOT NULL, -- 비밀번호 (SHA-256 해시)
  salt VARCHAR(128), -- 솔트 (SHA-256 해싱처리시 필요)
  name VARCHAR(255) NOT NULL, -- 닉네임
  nickname VARCHAR(255) NOT NULL, -- 닉네임
  profile_img VARCHAR(255), -- 사용자가 등록한 이미지 이름
  img_src VARCHAR(255), -- 서버에 저장한 이름
  reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 등록 날짜 (기본값: 현재 시간)
);

-- 올림픽 이벤트 정보를 저장하는 테이블 생성
CREATE TABLE olympics (
  olympics_id INT AUTO_INCREMENT PRIMARY KEY, -- 올림픽 ID (자동 증가)
  user_id INT NOT NULL, -- 올림픽 생성자 ID (외래키)
  olympics_name VARCHAR(255) NOT NULL, -- 올림픽 이름
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE NO ACTION -- 사용자 삭제 시 연쇄 삭제
);

-- 플레이어 정보를 저장하는 테이블 생성
CREATE TABLE players (
  player_id INT AUTO_INCREMENT PRIMARY KEY, -- 플레이어 ID (자동 증가)
  olympics_id INT, -- 참여한 올림픽 ID (외래키)
  player_name VARCHAR(255) NOT NULL, -- 플레이어 이름
  total_score INT DEFAULT 0, -- 누적 점수 (기본값: 0)
  reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 등록 날짜 (기본값: 현재 시간)
  FOREIGN KEY (olympics_id) REFERENCES olympics(olympics_id) ON DELETE CASCADE ON UPDATE NO ACTION -- 올림픽 삭제 시 연쇄 삭제
);

-- 챌린지 정보를 저장하는 테이블 생성
CREATE TABLE challenges (
  challenge_id INT AUTO_INCREMENT PRIMARY KEY, -- 챌린지 ID (자동 증가)
  challenge_name VARCHAR(255) NOT NULL, -- 챌린지 이름
  challenge_desc TEXT, -- 챌린지 설명
  challenge_url TEXT, -- 챌린지 영상 url
  reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 등록 날짜 (기본값: 현재 시간)
);

-- 챌린지에서 획득한 점수를 저장하는 테이블 생성
CREATE TABLE challenge_scores (
  score_id INT AUTO_INCREMENT PRIMARY KEY, -- 점수 ID (자동 증가)
  challenge_id INT, -- 챌린지 ID (외래키)
  player_id INT, -- 플레이어 ID (외래키)
  score INT NOT NULL, -- 획득한 점수
  reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 등록 날짜 (기본값: 현재 시간)
  FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON DELETE CASCADE ON UPDATE NO ACTION, -- 챌린지 삭제 시 연쇄 삭제
  FOREIGN KEY (player_id) REFERENCES players(player_id) ON DELETE CASCADE ON UPDATE NO ACTION -- 플레이어 삭제 시 연쇄 삭제
);

-- 챌린지에 대한 댓글을 저장하는 테이블 생성
CREATE TABLE comments (
  comment_id INT AUTO_INCREMENT PRIMARY KEY, -- 댓글 ID (자동 증가)
  user_id INT, -- 사용자 ID (외래키)
  challenge_id INT, -- 챌린지 ID (외래키)
  comment_depth INT DEFAULT 0, -- 0 이면 댓글, 1이면 대댓글
  comment_group INT, -- 댓글 그룹 (원댓글 ID)
  comment_text VARCHAR(255) NOT NULL, -- 댓글 내용
  reg_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 등록 날짜 (기본값: 현재 시간)
  update_date TIMESTAMP DEFAULT NULL, -- 수정 날짜 (NULL 가능)
  is_deleted TINYINT(1) DEFAULT 0, -- 1이면 삭제된 댓글
  FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE ON UPDATE NO ACTION, -- 사용자 삭제 시 연쇄 삭제
  FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON DELETE CASCADE ON UPDATE NO ACTION -- 챌린지 삭제 시 연쇄 삭제
);

CREATE INDEX idx_comments_challenge_id ON comments(challenge_id);
CREATE INDEX idx_comments_user_id ON comments(user_id);
CREATE INDEX idx_users_user_id ON users(user_id);

######################################## DML ########################################

INSERT INTO `users` VALUES 
(1,'ssafy1@ssafy.com','c3470dfd5cd105404a810b8918b02d3361504488c75217271f9437b89b97b6ef','RSnrbJXTNFcKoBEOO0+9Mg==','사용자1','닉네임1','profile1.png','http://localhost:8080/uploads/profile/78914804586c4da9bb77458b98ea2488_profile1.png','2024-11-22 09:22:14'),
(2,'ssafy2@ssafy.com','1d51a91c578fb1f78bcea1742c166a390a610fc811d1db4390e9cbde84d850c2','BoCz9/55lTyviygWfRPzhQ==','사용자2','닉네임2',NULL,NULL,'2024-11-22 09:22:46'),
(3,'ssafy3@ssafy.com','0213101a8f9e20dfa242f40ebdec280a8a5ffb4b0585b8beb1e05c05895a6cae','FBAk4IJDZpUT0nUUV+WwtQ==','사용자3','닉네임3','kermit.png','http://localhost:8080/uploads/profile/374f198308574977bf4b94fa2f42b629_kermit.png','2024-11-22 09:23:15'),
(4,'ssafy4@ssafy.com','0097975238e8f89cdd0d0ada0489a3fa4081140d0f1d39244ccccf989d3b5320','84TFXqq2pbZQrb9D53au9g==','사용자4','닉네임4', 'bebe.jpg', 'http://localhost:8080/uploads/profile/8fdde37a21754a728bc0ce1ae45e6d8e_bebe.jpg', '2024-11-22 09:23:40');

INSERT INTO olympics (user_id, olympics_name) VALUES
(1, '팀 A 올림픽'),
(2, '팀 B 올림픽'),
(3, '팀 C 올림픽');

INSERT INTO players (olympics_id, player_name) VALUES
(1, '플레이어1'),
(1, '플레이어2'),
(1, '플레이어3'),
(2, '플레이어4'),
(2, '플레이어5'),
(2, '플레이어6'),
(3, '플레이어7'),
(3, '플레이어8'),
(3, '플레이어9');

INSERT INTO challenges (challenge_id, challenge_name, challenge_desc, challenge_url) VALUES
(1, '재활용 전에 볼링 한 판은 괜찮잖아', '깨끗이 씻은 플라스틱 컵 6개를 세워 볼리핀으로 사용합니다. 폐지로 만든 공이나 박스테이프를 굴려 컵들을 쓰러뜨려야 합니다. 각 참가자는 3라운드의 기회를 가지며, 쓰러뜨린 개수의 총합으로 순위가 결정됩니다. 가장 많이 컵을 쓰러트린 참가자부터 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/yGbGhBmzdqM'),
(2, '자네 책 좀 읽게', '참가자들은 각자 책을 골라 아무 페이지를 펼칩니다. 페이지를 펼쳤을 때 사람 얼굴이 가장 많이 나온 페이지를 편 참가자가 우승합니다. 각 참가자는 2번의 기회를 가지며, 사람 얼굴이 가장 많이 나온 페이지를 편 참가자부터 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/pVfZPK9s27o'),
(3, '오피스 레이싱', '사무실의 바퀴 의자를 타고 정해진 코스를 완주하는 속도를 겨루는 게임입니다. 손으로 벽을을 밀거나 다리로 추진력을 이용할 수 있습니다. 코스에서 벗어나면 반칙 패가 적용되어 꼴찌가 됩니다. 1등은 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/NXpimdWiwKs'),
(4, '사무용품 서리 챌린지', '책, 마우스, 스테이플러, 포스트잇, 키보드 등 사무용품을 손 위에 올리고 10초 동안 유지하는 사람이 승리합니다. 물건이 떨어지거나 반대 손으로 잡으면 실격 처리됩니다. 가장 많은 사무용품을 가장 많이 서리해간 참가자는 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/OD3QIee8XsI'),
(5, '안녕히 계세요 여러분!', '종이비행기를 접어 가장 멀리 날리는 참가자가 승리합니다. 각 참가자는 2번의 기회를 가지며, 비행기가 멈춘 지점까지의 거리를 측정합니다. 날리는 방향에 맞춰 장애물(의자, 책상)을 피해야 합니다. 가장 멀리 던진 참가자는 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/AAL-kl5SuFs'),
(6, '신입이 쏘아올린 3점 슛', '종이 뭉치로 만든 작은 공이나 동그란 물체를 사용해 쓰레기통에 가장 많이 넣는 게임입니다. 각 참가자는 60초 동안 최대한 많은 성공을 기록해야 합니다. 쓰레기통이 넘어가면 해당 라운드는 무효 처리됩니다. 가장 많이 공을 넣은 참가자부터 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/C-_cv2yo27I'),
(7, '스테이플러 컬링', '참가자들은 스테이플러를 책상 끝으로 던져 가장 책상 끝에 가까이 도달한 사람 순서대로 높은 점수를 획득합니다. 각 참가자는 2번의 기회를 가지며, 가장 좋은 기록만 인정됩니다. 안전을 위해 반드시 빈 스테이플러를 사용하세요. 가장 가까운 순서부터 10점 그리고 다음 순서부터 1점씩 점수가 차감됩니다.', 'https://youtu.be/eluXLcmZfX4'),
(8, '회의실 의자 탈출', '참가자는 바퀴가 달린 의자에 앉아 벽을 발로 밀어 최대한 멀리 회의장으로부터 벗어나야 합니다. 각 참가자는 2번의 시도를 할 수 있으며, 가장 먼 기록만 채택됩니다. 의자가 코스를 벗어나거나 뒤집히면 해당 라운드는 무효 처리됩니다. 가장 멀리간 참가자부터 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/RQUOG-Sm6OU'),
(9, '포스트잇 견뎌!', '60초 동안 얼굴에 최대한 많은 포스트잇을 붙이는 게임입니다. 포스트잇은 반드시 한 면만 접착되어야 하며, 60초 후에 떨어진 포스트잇은 점수에서 제외됩니다. 가장 많은 포스트잇을 붙인 사람이 가장 높은 점수를 획득합니다. 포스트잇 1장당 10점을 얻습니다.', 'https://youtu.be/lYiZSGJysJw'),
(10, '폐기 서류의 탑', '폐기해야하는 서류를 준비합니다. 참가자들은 주어진 시간 동안 책상 위에 서류를 종이접기를 하여 최대한 높이 쌓아야 합니다. 서류가 무너지면 해당 라운드의 점수는 0점 처리됩니다. 안정성과 높이를 동시에 고려해야 합니다. 쌓은 높이(cm)가 여러분의 점수입니다.', 'https://youtu.be/KSwu3DkjJeU'),
(11, '너와! 나의! 클립고리!', '2분 안에 클립을 연결하여 가장 긴 체인을 만들어야 합니다. 연결이 느슨해서 끊어지면 끊어진 클립들의 갯수는 점수에서 제외됩니다. 점수는 완성한 클립 연결 고리의 클립 갯수를 입력합니다.', 'https://youtu.be/8Lcbgw2TOGI'),
(12, '병뚜껑 알까기', '참가자는 병뚜껑으로 다른 참가자의 병뚜껑을 튕겨서 사무실 책상에서 떨어뜨려야 합니다. 각 참가자는 2개의 병뚜껑을 가지고 시작합니다. 마지막까지 살아남은 병뚜껑 참가자가 승리합니다. 살아남은 1인은 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/voE9PbnPLvQ'),
(13, '타이핑: 누구보다 빠르게 남들과는 다르게', '1분 동안 주어진 텍스트를 가장 빠르고 정확하게 타이핑한 사람이 승리합니다. 오타가 있을 경우 단어당 1초의 패널티가 적용됩니다. 속도와 정확도가 중요한 게임입니다. 가장 빠르고 정확하게 타자한 참가자가 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/sr4-2GCkQDg'),
(14, '추억의 딱지 치기', '각 참가자는 자신이 접은 딱지로 상대방의 딱지를 뒤집어야 합니다. 각 라운드마다 3번의 시도가 주어지며, 상대 딱지를 뒤집으면 승리입니다. 딱지가 찢어지거나 규칙 외의 방식으로 뒤집을 경우 실격 처리됩니다. 토너먼트를 통해 우승자를 가리고 우승자는 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/vratLobEb7o'),
(15, '종이컵 피라미드', '제한된 시간 안에 종이컵으로 피라미드를 최대한 높이 쌓는 게임입니다. 종이컵이 무너지면 점수가 무효 처리됩니다. 안정성과 속도를 모두 고려해야 합니다. 가장 피라미드를 높게 쌓은 참가자부터 10점 그리고 다음 순서부터 1점씩 차감됩니다.', 'https://youtu.be/91ZROJ-yv8M');


INSERT INTO challenge_scores (challenge_id, player_id, score) VALUES
(1, 1, 35),
(2, 1, 30),
(3, 1, 25),
(1, 2, 28),
(2, 2, 32),
(3, 2, 30),
(1, 3, 25),
(2, 3, 28),
(3, 3, 33),
(1, 4, 40),
(2, 4, 38),
(3, 4, 35),
(1, 5, 37),
(2, 5, 35),
(3, 5, 33),
(1, 6, 30),
(2, 6, 33),
(3, 6, 32),
(1, 7, 45),
(2, 7, 42),
(3, 7, 40),
(1, 8, 40),
(2, 8, 37),
(3, 8, 38),
(1, 9, 35),
(2, 9, 32),
(3, 9, 33);

UPDATE players
SET total_score = (
					SELECT SUM(score) * 100
					FROM challenge_scores 
					WHERE challenge_scores.player_id = players.player_id), reg_date = NOW();


INSERT INTO comments (user_id, challenge_id, comment_depth, comment_group, comment_text, reg_date, update_date) VALUES
(1, 1, 0, 1, '정말 재미있는 도전이었어요!', '2024-11-20 12:00:00', NULL),
(2, 1, 1, 1, '저도 정말 즐겁게 완료했어요!', '2024-11-20 12:00:00', NULL),
(3, 1, 1, 1, '다음에 또 도전하고 싶습니다.', '2024-11-20 12:00:00', NULL),
(1, 2, 0, 2, '스스로에게 좋은 동기부여가 되었습니다.', '2024-11-20 12:00:00', NULL),
(2, 2, 1, 2, '저도 같은 생각입니다. 너무 좋았어요!', '2024-11-20 12:00:00', NULL),
(1, 3, 0, 3, '친구들과 함께 참여해서 즐거웠습니다.', '2024-11-20 12:00:00', NULL),
(2, 3, 1, 3, '정말 보람찬 시간이었습니다.', '2024-11-20 12:00:00', NULL),
(3, 3, 1, 3, '다른 사람들과도 공유하고 싶어요.', '2024-11-20 12:00:00', NULL),
(1, 4, 0, 4, '이 챌린지를 통해 새로운 것을 배웠습니다.', '2024-11-20 12:00:00', NULL),
(2, 4, 1, 4, '저도 많은 것을 배울 수 있었습니다.', '2024-11-20 12:00:00', NULL),
(3, 5, 0, 5, '도전 과정이 잘 짜여져 있어요.', '2024-11-20 12:00:00', NULL),
(1, 5, 1, 5, '끝까지 도전할 수 있어서 기뻤습니다.', '2024-11-20 12:00:00', NULL),
(2, 6, 0, 6, '진행 방법이 명확해서 쉽게 따라 할 수 있었어요.', '2024-11-20 12:00:00', NULL),
(3, 6, 1, 6, '다음 번에도 비슷한 도전을 하고 싶습니다.', '2024-11-20 12:00:00', NULL),
(1, 7, 0, 7, '완료했을 때 뿌듯했습니다.', '2024-11-20 12:00:00', NULL),
(2, 7, 1, 7, '정말 의미 있는 시간이었어요.', '2024-11-20 12:00:00', NULL),
(3, 8, 0, 8, '다음에도 참여할 계획입니다.', '2024-11-20 12:00:00', NULL),
(1, 8, 1, 8, '저도 같은 생각이에요. 너무 좋았습니다.', '2024-11-20 12:00:00', NULL),
(2, 9, 0, 9, '스스로의 한계를 극복한 느낌이었어요.', '2024-11-20 12:00:00', NULL),
(3, 9, 1, 9, '정말 보람찬 경험이었습니다.', '2024-11-20 12:00:00', NULL),
(1, 10, 0, 10, '완료 후의 성취감이 컸습니다.', '2024-11-20 12:00:00', NULL),
(2, 10, 1, 10, '다음에도 꼭 참여하고 싶습니다.', '2024-11-20 12:00:00', NULL),
(3, 11, 0, 11, '모두와 함께 도전해서 즐거웠습니다.', '2024-11-20 12:00:00', NULL),
(1, 11, 1, 11, '저도 만족스러운 경험이었어요.', '2024-11-20 12:00:00', NULL),
(2, 12, 0, 12, '다른 도전도 참여하고 싶습니다.', '2024-11-20 12:00:00', NULL),
(3, 12, 1, 12, '진행이 잘 준비되어 있었습니다.', '2024-11-20 12:00:00', NULL),
(1, 13, 0, 13, '제 자신에게 큰 성취를 안겨준 도전이에요.', '2024-11-20 12:00:00', NULL),
(2, 13, 1, 13, '정말 만족스러운 시간이었습니다.', '2024-11-20 12:00:00', NULL),
(3, 14, 0, 14, '다음에 또 참여하고 싶습니다.', '2024-11-20 12:00:00', NULL),
(1, 14, 1, 14, '정말 의미 있는 도전이었어요.', '2024-11-20 12:00:00', NULL),
(2, 15, 0, 15, '모두에게 보람찬 도전이 될 것입니다.', '2024-11-20 12:00:00', NULL),
(3, 15, 1, 15, '함께한 모든 분들께 감사드립니다.', '2024-11-20 12:00:00', NULL);

