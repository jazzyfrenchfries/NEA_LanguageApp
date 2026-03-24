--NEA Database Script
-- This code creates all the SQL tables required for this project
-- Can be executed in SQL Server 

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConjugationBank](
	[ConjugationID] [int] IDENTITY(1,1) NOT NULL,
	[Verb] [nvarchar](100) NOT NULL,
	[Pronoun] [nvarchar](50) NOT NULL,
	[Tense] [nvarchar](50) NOT NULL,
	[CorrectAnswer] [nvarchar](200) NOT NULL,
	[Hint] [nvarchar](200) NULL,
	[Options] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ConjugationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ListeningBank](
	[ListeningID] [int] IDENTITY(1,1) NOT NULL,
	[AudioPath] [nvarchar](300) NOT NULL,
	[CorrectAnswer] [nvarchar](200) NOT NULL,
	[FullText] [nvarchar](max) NOT NULL,
	[Hint] [nvarchar](255) NULL,
	[Options] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[ListeningID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[Username] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](100) NULL,
	[PasswordHash] [nvarchar](200) NOT NULL,
	[TotalScore] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[Username] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT ((0)) FOR [TotalScore]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[UserScores](
	[ScoreID] [int] IDENTITY(1,1) NOT NULL,
	[UserID] [int] NOT NULL,
	[ExerciseType] [nvarchar](20) NOT NULL,
	[ExerciseID] [int] NOT NULL,
	[Score] [int] NOT NULL,
	[Correct] [bit] NOT NULL,
	[DateCompletedLast] [datetime2](7) NULL,
PRIMARY KEY CLUSTERED 
(
	[ScoreID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[UserScores] ADD  DEFAULT (sysutcdatetime()) FOR [DateCompletedLast]
GO
ALTER TABLE [dbo].[UserScores]  WITH CHECK ADD FOREIGN KEY([UserID])
REFERENCES [dbo].[Users] ([UserID])
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VocabularyBank](
	[VocabID] [int] IDENTITY(1,1) NOT NULL,
	[FrenchWord] [nvarchar](100) NOT NULL,
	[Translation] [nvarchar](100) NOT NULL,
	[Hint] [nvarchar](200) NULL,
	[Options] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[VocabID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO ConjugationBank (Verb, Pronoun, Tense, CorrectAnswer, Hint, Options)
VALUES
('être', 'je', 'Present', 'suis', 'irregular', 'present tense verbs'),
('être', 'tu', 'Present', 'es', 'irregular', 'present tense verbs'),
('être', 'il/elle', 'Present', 'est', 'irregular', 'present tense verbs'),
('avoir', 'j’', 'Present', 'ai', 'irregular', 'present tense verbs'),
('avoir', 'nous', 'Present', 'avons', 'irregular', 'present tense verbs'),
('aller', 'je', 'Present', 'vais', 'irregular', 'present tense verbs'),
('aller', 'nous', 'Present', 'allons', 'irregular', 'present tense verbs'),
('faire', 'je', 'Present', 'fais', 'irregular', 'present tense verbs'),
('faire', 'nous', 'Present', 'faisons', 'nous form', 'present tense verbs'),
('aller', 'je', 'Perfect', 'suis allé', 'uses être', 'perfect tense verbs'),
('aller', 'elle', 'Perfect', 'est allée', 'agreement', 'perfect tense verbs'),
('faire', 'j’', 'Perfect', 'ai fait', 'avoir verb', 'perfect tense verbs');
GO 

INSERT INTO VocabularyBank (FrenchWord, Translation, Hint, Options)
VALUES
('le bénévole', 'volunteering', 'v...', 'Basic'),
('manger', 'to eat', 'regular -er verb', 'Food'),
('boire', 'to drink', 'irregular verb', 'Food'),
('le petit déjeuner', 'breakfast', 'morning meal', 'Food'),
('le déjeuner', 'lunch', 'midday meal', 'Food'),
('le dîner', 'dinner', 'evening meal', 'Food'),
('le pain', 'bread', 'bakery item', 'Food'),
('le fromage', 'cheese', 'dairy product', 'Food'),
('la viande', 'meat', 'protein food', 'Food'),
('le poisson', 'fish', 'seafood', 'Food'),
('les légumes', 'vegetables', 'plural noun', 'Food'),
('l’école', 'school', 'feminine noun', 'School');
GO

INSERT INTO ListeningBank (AudioPath, CorrectAnswer, FullText, Hint, Options)
VALUES
('audio/listening1.mp3', 'sportif', 'Salut ! Aujourd’hui je vais parler de ma famille. J’ai un frère qui s’appelle Lucas. Il est très ____. Il aime jouer au foot.', 'It means sporty', 'Basic'),
('audio/listening2.mp3', 'l''avenir', 'À l''______, je danserai tous les jours car c''est mon rêve.', 'means future', 'Basic'),
('audio/listening3.mp3', 'nécessaire', 'Il est __________ de manger avec précaution afin de ne pas trop manger.', 'necessary in french', 'Medium'),
('audio/listening4.mp3', 'demander', 'Je veux _______ un nouveau document pour le ministre de France', 'to demand', 'Basic'),
('audio/listening5.mp3', 'lorsque', 'Nous parlons français _______ nous sommes dehors, à l''école ou au marché.', 'another word for quand', 'Basic'),
('audio/listening6.mp3', 'se retrouver', 'La majorité des Français fête Pâques et considère cette date comme une occasion de __ _________ en famille pour partager un bon repas.', 'reflexive verb', 'Medium'),
('audio/listening7.mp3', 'endroit', 'Le centre commercial est l''_____ idéal pour passer un bon moment avec sa famille, ses amis ou ses collègues de travail.', 'space', 'Medium');
GO 

INSERT INTO Users (Username, Email, PasswordHash, TotalScore)
VALUES
('testuser1', NULL, 'z4DNiu1ILV0VJ9fccvzv+E5jJlkoSER9LcCw6H38mpA=', 57),
('testuser2', NULL, 'koBzaePtIA+EhkcVXBa/cbCUH1tIJ+nG1VLpIrpRrN8=', 14),
('testuser3', NULL, '88d2ndRdUcvTOiEFEkJ0t137Q+zAKNiZwjE6Ty8Plc4=', 4),
('testuser5', NULL, '6SYQohWcmZx8XyxGrcw6lvsqiqSh7g3Xyh1K2SUBCc0=', 0),
('testuser4', NULL, 'n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=', 9);
GO

INSERT INTO UserScores (UserID, ExerciseType, ExerciseID, Score, Correct, DateCompletedLast)
VALUES
(1, 'Conjugation', 1, 1, 1, '2025-12-09 12:43:05'),
(1, 'Listening', 1, 1, 1, '2025-12-12 09:25:24'),
(1, 'Listening', 1, 1, 1, '2025-12-12 12:38:55'),
(1, 'Listening', 1, 1, 1, '2025-12-15 14:44:08'),
(1, 'Listening', 1, 1, 1, '2025-12-19 11:59:56');
GO