using Microsoft.Data.SqlClient;
using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;
using System;
using System.Security.Cryptography;
using Microsoft.AspNetCore.Cryptography.KeyDerivation;
using System.Text;


public class DatabaseService
{
    private readonly string _conn;

    public DatabaseService(IConfiguration configuration)
    {
        if(configuration == null)
        {
            throw new ArgumentNullException(nameof(configuration));
        }
        _conn = configuration.GetConnectionString("FrenchDb");
        Console.WriteLine("=== Active Connection String");
        Console.WriteLine(_conn);
    }

    public string HashPassword(string password)
    {
        using var sha = SHA256.Create();
        byte[] bytes = Encoding.UTF8.GetBytes(password);
        byte[] hash = sha.ComputeHash(bytes);
        return Convert.ToBase64String(hash);
    }
    public async Task<bool> RegisterUserAsync(string username, string password)
    {
        string hashed = HashPassword(password);
        using var con = new SqlConnection(_conn);
        using var cmd = new SqlCommand("INSERT INTO Users (Username, PasswordHash) VALUES(@u, @p)", con);
        cmd.Parameters.AddWithValue("@u", username);
        cmd.Parameters.AddWithValue("@p", hashed);
        await con.OpenAsync();
        try
        {
            await cmd.ExecuteNonQueryAsync();
            return true;
        }
        catch (SqlException)
        {
            return false;
        }
    }
    public async Task<User> LoginUserAsync(string username, string password)
    {
        string hashed = HashPassword(password);
        using var con = new SqlConnection(_conn);
        using var cmd = new SqlCommand(
            "SELECT UserId, Username, PasswordHash, ISNULL(TotalScore,0) AS TotalScore FROM Users WHERE Username=@u", con);
        cmd.Parameters.AddWithValue("@u", username);

        await con.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            var storedHash = reader.GetString(2);
            if (storedHash == hashed)
            {
                return new User
                {
                    UserID = reader.GetInt32(0),
                    Username = reader.GetString(1),
                    TotalScore = reader.GetInt32(3)
                };

            }
        }
        return null;
    }
    public async Task<User> LogoutUserAsync(string username, string password)
    {
       // put logout thing here :) 
        return null;
    }
    public async Task<List<VocabItem>> GetVocabularyAsync()
    {
        var list = new List<VocabItem>();

        using (var conn = new SqlConnection(_conn))
        using (var cmd = conn.CreateCommand())
        {
            cmd.CommandText = "SELECT VocabID, FrenchWord, Translation, Hint FROM VocabularyBank";
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                list.Add(new VocabItem
                {
                    VocabID = reader.GetInt32(0),
                    FrenchWord = reader.GetString(1),
                    Translation = reader.IsDBNull(2) ? null : reader.GetString(2),
                    Hint = reader.IsDBNull(3) ? null : reader.GetString(3)
                });
            }
        }

        return list;
    }

    public async Task<List<ListeningItem>> GetListeningsAsync()
    {
        var list = new List<ListeningItem>();
        using var conn = new SqlConnection(_conn);
        using var cmd = new SqlCommand(
            "SELECT ListeningID, AudioPath, CorrectAnswer, FullText, Hint FROM ListeningBank", conn
        );

        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            list.Add(new ListeningItem
            {
                ListeningID = reader.GetInt32(0),
                AudioPath = reader.GetString(1),
                CorrectAnswer = reader.GetString(2),
                FullText = reader.GetString(3),
                Hint = reader.GetString(4)

            });
        }


        return list;
    }
    public async Task<List<ConjugationItem>> GetConjugationAsync()
    {
        var list = new List<ConjugationItem>();
        using var conn = new SqlConnection(_conn);
        using var cmd = new SqlCommand(
            "SELECT ConjugationID, Verb , Pronoun,  Tense ,CorrectAnswer, Hint FROM ConjugationBank", conn
        ); 
            
            await conn.OpenAsync();
            using var reader = await cmd.ExecuteReaderAsync();
            while (await reader.ReadAsync())
            {
                list.Add(new ConjugationItem
                {
                    ConjugationID = reader.GetInt32(0),
                    Verb = reader.GetString(1),
                    Pronoun = reader.GetString(2),
                    Tense = reader.GetString(3),
                    CorectAnswer = reader.GetString(4),
                    Hint = reader.GetString(5)

                });
            }

        
        return list;
    }

    // Example: check login
    public async Task<User> GetUserByUsernameAsync(string username)
    {
        using var conn = new SqlConnection(_conn);
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT UserID, Username,TotalScore FROM Users WHERE Username=@u";
        cmd.Parameters.AddWithValue("@u", username);
        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        if (await reader.ReadAsync())
        {
            return new User {
                UserID = reader.GetInt32(0),
                Username = reader.GetString(1),
                TotalScore = reader.GetInt32(2)
            };
        }
        return null;
    }

    // Example: save a user score
    public async Task SaveUserScoreAsync(int userId, string exerciseType, int exerciseId, int score, bool correct)
    {
        using var conn = new SqlConnection(_conn);
        using var cmd = conn.CreateCommand();
        cmd.CommandText = @"
            INSERT INTO UserScores (UserID,ExerciseType,ExcersiseID,Score,Correct,DateCompletedLast)
            VALUES (@uid,@type,@exid,@score,@correct, GETDATE());
            UPDATE Users SET TotalScore = TotalScore + @score WHERE UserID = @uid;
        ";
        cmd.Parameters.AddWithValue("@uid", userId);
        cmd.Parameters.AddWithValue("@type", exerciseType);
        cmd.Parameters.AddWithValue("@exid", exerciseId);
        cmd.Parameters.AddWithValue("@score", score);
        cmd.Parameters.AddWithValue("@correct", correct ? 1 : 0);

        await conn.OpenAsync();
        await cmd.ExecuteNonQueryAsync();
    }

    // Example: get leaderboard (top N)
    public async Task<List<User>> GetLeaderboardAsync(int topN = 20)
    {
        var list = new List<User>();
        using var conn = new SqlConnection(_conn);
        using var cmd = conn.CreateCommand();
        cmd.CommandText = "SELECT TOP(@n) UserID, Username, TotalScore FROM Users ORDER BY TotalScore DESC";
        cmd.Parameters.AddWithValue("@n", topN);
        await conn.OpenAsync();
        using var reader = await cmd.ExecuteReaderAsync();
        while (await reader.ReadAsync())
        {
            list.Add(new User {
                UserID = reader.GetInt32(0),
                Username = reader.GetString(1),
                TotalScore = reader.GetInt32(2)
            });
        }
        return list;
    }
}