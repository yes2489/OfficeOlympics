package com.olympics.mvc.model.service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.olympics.mvc.model.dao.ChallengeScoreDao;
import com.olympics.mvc.model.dto.Challenge;
import com.olympics.mvc.model.dto.Rank;
import com.olympics.mvc.model.dto.Score;

@Service
@Transactional(rollbackFor = {Exception.class})
public class ChallengeScoreServiceImpl implements ChallengeScoreService{
	
	private final ChallengeScoreDao challengeDao;
	
	public ChallengeScoreServiceImpl(ChallengeScoreDao challengeDao) {
		this.challengeDao = challengeDao;
	}

	@Override
	public List<Challenge> getChallenges() {
		return challengeDao.getChallenges();
	}

	@Override
	public Challenge selectChallenge(int challengeId) {
		return challengeDao.selectChallenge(challengeId);
	}

	
	@Override
	@Transactional
	public boolean upsertScores(Score score) {
		// 이름을 ID로 변환
	    List<Integer> ids = challengeDao.nameToId(score.getPlayerNames());
	    score.setPlayerId(ids);

	    // 변환된 데이터를 insert에 사용 가능한 형태로 준비
	    List<Map<String, Object>> scoreData = new ArrayList<>();
	    for (int i = 0; i < score.getScores().size(); i++) {
	        Map<String, Object> map = new HashMap<>();
	        map.put("challengeId", score.getChallengeId());
	        map.put("playerId", score.getPlayerId().get(i));
	        map.put("score", score.getScores().get(i));
	        scoreData.add(map);
	    }
	    
	    // challenge_id와 player_id에 대응하는 score_id가 있는지 확인
	    int isExist = challengeDao.findScoreId(scoreData);
	    
	    // 있으면 update, 없으면 insert 진행
	    if(isExist > 0) {
	    	return challengeDao.updateScore(scoreData) > 0;
	    } else {
	    	return challengeDao.insertScore(scoreData) > 0;
	    }
	}
	
	
	@Override
	@Transactional
	public void updateTotalScore() {
		challengeDao.updateTotalScore();
	}

	@Override
	public List<Rank> selectChallengeScore(int challengeId, int olympicsId) {
		Map<String, Object> params = new HashMap<>();
		params.put("challengeId", challengeId);
		params.put("olympicsId", olympicsId);
		
		return challengeDao.selectChallengeScore(params);
	}

	@Override
	public List<Rank> selectFinalScore(int olympicsId) {
		return challengeDao.selectFinalScore(olympicsId);
	}

}
