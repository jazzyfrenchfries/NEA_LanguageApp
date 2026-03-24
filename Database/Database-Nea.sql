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

INSERT INTO ConjugationBank (ConjugationID, Verb, Pronoun, CorrectAnswer,Hint,  Options)
VALUES(
	1	être	je	Present	suis	irregular	present tense verbs
2	être	tu	Present	es	irregular	present tense verbs
3	être	il/elle	Present	est	irregular	present tense verbs
4	avoir	j’	Present	ai	irregular	present tense verbs
5	avoir	nous	Present	avons	irregular	present tense verbs
6	aller	je	Present	vais	irregular	present tense verbs
7	aller	nous	Present	allons	irregular	present tense verbs
8	faire	je	Present	fais	irregular	present tense verbs
9	faire	nous	Present	faisons	nous form	present tense verbs
10	aller	je	Perfect	suis allé	uses être	perfect tense verbs
11	aller	elle	Perfect	est allée	agreement	perfect tense verbs
12	faire	j’	Perfect	ai fait	avoir verb	perfect tense verbs
)
INSERT INTO VocabularyBank( VocabID, FrenchWord, Translation, Hint, Options )
VALUES(
	1	le bénévole	volunteering	v...	Basic
2	manger	to eat	regular -er verb	Food
3	boire	to drink	irregular verb	Food
4	le petit déjeuner	breakfast	morning meal	Food
5	le déjeuner	lunch	midday meal	Food
6	le dîner	dinner	evening meal	Food
7	le pain	bread	bakery item	Food
8	le fromage	cheese	dairy product	Food
9	la viande	meat	protein food	Food
10	le poisson	fish	seafood	Food
11	les légumes	vegetables	plural noun	Food
12	l’école	school	feminine noun	School
)
INSERT INTO ListeningBank( )
VALUES( 1	audio/listening1.mp3	sportif	Salut ! Aujourd’hui je vais parler de ma famille. J’ai un frère qui s’appelle Lucas. Il est très ____. Il aime jouer au foot.	It means sporty	Basic
2	audio/listening2.mp3	l'avenir	À l'______, je danserai tous les jours car c'est mon rêve.	means future	Basic
3	audio/listening3.mp3	nécessaire	Il est __________ de manger avec précaution afin de ne pas trop manger.	necessary in french 	Medium
4	audio/listening4.mp3	demander	Je veux _______ un nouveau document pour le ministre de France 	to demand	Basic
5	audio/listening5.mp3	lorsque	Nous parlons français _______ nous sommes dehors, à l'école ou au marché.	another word for quand	Basic
6	audio/listening6.mp3	se retrouver	La majorité des Français fête Pâques et considère cette date comme une occasion de __ _________ en famille pour partager un bon repas.	reflexive verb	Medium
7	audio/listening7.mp3	endroit	Le centre commercial est l'_____ idéal pour passer un bon moment avec sa famille, ses amis ou ses collègues de travail.	space	Medium)
INSERT INTO Users(UserID, Username, Email, PasswordHash, TotalScore)
VALUES (
	1	testuser1	NULL	z4DNiu1ILV0VJ9fccvzv+E5jJlkoSER9LcCw6H38mpA=	57
2	testuser2	NULL	koBzaePtIA+EhkcVXBa/cbCUH1tIJ+nG1VLpIrpRrN8=	14
10	testuser3	NULL	88d2ndRdUcvTOiEFEkJ0t137Q+zAKNiZwjE6Ty8Plc4=	4
19	testuser5	NULL	6SYQohWcmZx8XyxGrcw6lvsqiqSh7g3Xyh1K2SUBCc0=	0
22	testuser4	NULL	n4bQgYhMfWWaL+qgxVrQFaO/TxsrC4Is0V1sFbDwCgg=	9
)
INSERT INTO UserScores(UserID , ExerciseType, ExerciseID,  Score, Correct, DateLastCompleted)
1	1	Conjugation	1	1	1	2025-12-09 12:43:05.7400000
2	1	Listening	1	1	1	2025-12-12 09:25:24.8200000
3	1	Listening	1	1	1	2025-12-12 12:38:55.6133333
4	1	Listening	1	1	1	2025-12-15 14:44:08.2800000
5	1	Listening	1	1	1	2025-12-19 11:59:56.3200000
6	1	Conjugation	3	1	1	2025-12-27 12:27:41.1700000
7	1	Conjugation	8	1	1	2025-12-31 14:24:20.2233333
8	1	Listening	1	1	1	2026-01-05 09:58:49.2000000
9	1	Conjugation	5	1	1	2026-02-06 11:24:37.4566667
10	1	Conjugation	8	1	1	2026-02-06 11:24:41.8266667
11	1	Conjugation	3	1	1	2026-02-09 17:26:15.4600000
12	1	Conjugation	9	1	1	2026-02-09 18:27:39.0433333