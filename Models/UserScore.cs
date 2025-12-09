using Microsoft.Extensions.Configuration.UserSecrets;

public class UserScore
{
    public int ScoreID{get; set;}
    public int UserID{get; set;}
    public string ExerciseType{get; set;}
    public int ExerciseID{get; set;}
    public int Score {get; set;}
    public bool Correct{get; set;}
    public DateTime DateCompleted{get; set;}
}