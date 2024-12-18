package com.olympics.mvc.model.dto;

public class Rank {
	private int rank; // 등수
	private String playerName; 
	private int score; // 점수

	public Rank() {
		super();
	}
	
	public Rank(int rank, String playerName, int score) {
		super();
		this.rank = rank;
		this.playerName = playerName;
		this.score = score;
	}
	
	// getter, setter

	public int getRank() {
		return rank;
	}

	public void setRank(int rank) {
		this.rank = rank;
	}

	public String getPlayerName() {
		return playerName;
	}

	public void setPlayerName(String playerName) {
		this.playerName = playerName;
	}

	public int getScore() {
		return score;
	}

	public void setScore(int score) {
		this.score = score;
	}

	@Override
	public String toString() {
		return "Rank [rank=" + rank + ", playerName=" + playerName + ", score=" + score + "]";
	}
	
	
}
