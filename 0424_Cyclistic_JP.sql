USE Cyclistic;

-- 分析を始める前に、まずデータクリーニングをしなければなりません。まずはNumbersを使ってもとデータの確認をしました。
-- ですが、Numbersで作業を行うにはファイルデータが大きすぎました....
-- ですので、SQLを使って作業を行うことにしました。まずは、以下の通り空のテーブルから作成しました。

CREATE TABLE IF NOT EXISTS Cyclistic.20jul_data(
	ride_id VARCHAR(16) NOT NULL,
    rideable_type VARCHAR(20),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name VARCHAR(100),
    start_station_id INT,
    end_station_name VARCHAR(100),
    end_station_id INT,
    start_lat FLOAT,
    start_lng FLOAT,
    end_lat FLOAT,
    end_lng FLOAT,
    member_casual VARCHAR(10)
);

SELECT 
    *
FROM
    20jul_data;

-- 次に、他のcsvファイルのためのテーブルを複製していきます。
CREATE TABLE 20aug_data LIKE 20jul_data;
CREATE TABLE 20sep_data LIKE 20jul_data;
CREATE TABLE 20oct_data LIKE 20jul_data;
CREATE TABLE 20nov_data LIKE 20jul_data;
CREATE TABLE 20dec_data LIKE 20jul_data;
CREATE TABLE 21jan_data LIKE 20jul_data;
CREATE TABLE 21feb_data LIKE 20jul_data;
CREATE TABLE 21mar_data LIKE 20jul_data;
CREATE TABLE 21apr_data LIKE 20jul_data;
CREATE TABLE 21may_data LIKE 20jul_data;
CREATE TABLE 21jun_data LIKE 20jul_data;

-- テーブルができましたので、workbenchツールを使ってデータのインポートを実施しようと試みました。
-- ですが、容量が大きいのでかなりの時間がかかりそうでした（ファイルサイズは 9 - 154MB）.... 代わりに、Load Data Infile構文を使用しました。

SET GLOBAL local_infile = 1;
SHOW VARIABLES LIKE 'local_infile';

LOAD DATA LOCAL
INFILE 'input_datapath/202007-divvy-tripdata.csv'
INTO TABLE 20jul_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

SELECT * FROM 20jul_data
WHERE ride_id IS NULL;

SELECT COUNT(ride_id) FROM 20jul_data;

-- 一つのインポートが完了し、確認しました。うまくいっているようなので、他も実行していきます。

LOAD DATA LOCAL
INFILE 'input_datapath/202008-divvy-tripdata.csv'
INTO TABLE 20aug_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
    
LOAD DATA LOCAL
INFILE 'input_datapath/202009-divvy-tripdata.csv'
INTO TABLE 20sep_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202010-divvy-tripdata.csv'
INTO TABLE 20oct_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202011-divvy-tripdata.csv'
INTO TABLE 20nov_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202012-divvy-tripdata.csv'
INTO TABLE 20dec_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
    
LOAD DATA LOCAL
INFILE 'input_datapath/202101-divvy-tripdata.csv'
INTO TABLE 21jan_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202102-divvy-tripdata.csv'
INTO TABLE 21feb_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202103-divvy-tripdata.csv'
INTO TABLE 21mar_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202104-divvy-tripdata.csv'
INTO TABLE 21apr_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;
    
LOAD DATA LOCAL
INFILE 'input_datapath/202105-divvy-tripdata.csv'
INTO TABLE 21may_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

LOAD DATA LOCAL
INFILE 'input_datapath/202106-divvy-tripdata.csv'
INTO TABLE 21jun_data 
	FIELDS TERMINATED BY ','
	LINES TERMINATED BY '\n'
	IGNORE 1 ROWS;

select * from 21jun_data;

/*
ここで、全てのデータをインポートし終わりました。
次に、インポートしたデータを全てマージします。 
*/

CREATE VIEW all_data AS
	SELECT * FROM 20jul_data
UNION ALL
	SELECT * FROM 20aug_data
UNION ALL
	SELECT * FROM 20sep_data
UNION ALL
	SELECT * FROM 20oct_data
UNION ALL
	SELECT * FROM 20nov_data
UNION ALL
	SELECT * FROM 20dec_data
UNION ALL
	SELECT * FROM 21jan_data
UNION ALL
	SELECT * FROM 21feb_data
UNION ALL
	SELECT * FROM 21mar_data
UNION ALL
	SELECT * FROM 21apr_data
UNION ALL
	SELECT * FROM 21may_data
UNION ALL
	SELECT * FROM 21jun_data;

/*
一旦ファイルをエクスポートして内容を確認してみましたが、"member_casual"のフィルターには本来2つのはずが4つのデータが表示されていました。
なので、以下を実行しデータを正しい状態に戻します。
*/

update 20aug_data set member_casual = "Member" where member_casual LIKE "m%";
update 20aug_data set member_casual = "Casual" where member_casual LIKE "c%";

update 20dec_data set member_casual = "Member" where member_casual LIKE "m%";
update 20dec_data set member_casual = "Casual" where member_casual LIKE "c%";

update 20jul_data set member_casual = "Member" where member_casual LIKE "m%";
update 20jul_data set member_casual = "Casual" where member_casual LIKE "c%";

update 20nov_data set member_casual = "Member" where member_casual LIKE "m%";
update 20nov_data set member_casual = "Casual" where member_casual LIKE "c%";

update 20oct_data set member_casual = "Member" where member_casual LIKE "m%";
update 20oct_data set member_casual = "Casual" where member_casual LIKE "c%";

update 20sep_data set member_casual = "Member" where member_casual LIKE "m%";
update 20sep_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21apr_data set member_casual = "Member" where member_casual LIKE "m%";
update 21apr_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21feb_data set member_casual = "Member" where member_casual LIKE "m%";
update 21feb_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21jan_data set member_casual = "Member" where member_casual LIKE "m%";
update 21jan_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21jun_data set member_casual = "Member" where member_casual LIKE "m%";
update 21jun_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21mar_data set member_casual = "Member" where member_casual LIKE "m%";
update 21mar_data set member_casual = "Casual" where member_casual LIKE "c%";

update 21may_data set member_casual = "Member" where member_casual LIKE "m%";
update 21may_data set member_casual = "Casual" where member_casual LIKE "c%";

-- 完了後、データが2つのタイプしかないことを確認します。
select count(*) from all_data where member_casual NOT IN('Member', 'Casual');
-- 結果は0でした。

-- では次にさらにデータチェックを行なっていきます。

SELECT COUNT(*) FROM all_data
WHERE started_at IS NULL OR ended_at IS NULL;
-- 結果は0でした。

SELECT COUNT(*) FROM all_data
WHERE start_lat IS NULL OR start_lng IS NULL OR end_lat IS NULL OR end_lng IS NULL;
-- 結果は0でした。

SELECT COUNT(*) FROM all_data
WHERE member_casual IS NULL;
-- 結果は0でした。

SELECT COUNT(*) FROM all_data
WHERE start_station_id IS NULL;
/*
ここで、 start_station_name, start_station_id, end_station_name, end_station_idにはnull値が含まれていることが確認されました。
しかし、今回は分析に使いませんので、これらを含まないデータセットを新たに作成します。
*/

CREATE VIEW clean_data_1 AS (
	SELECT ride_id, rideable_type, started_at, ended_at, member_casual
    FROM all_data
);

SELECT SUM(ended_at - started_at) AS timediff, member_casual FROM clean_data_1 where started_at BETWEEN '2020-12-01' AND '2020-12-31' group by member_casual;
-- ここで、started_atとended_atで記録取得時にエラーが発生している場合もあると気づきました。
-- 今回はこれらのデータを"不備データ"とし、分析には使用しないこととしました。

CREATE VIEW clean_data_2 AS
    (SELECT 
        ride_id, rideable_type, started_at, ended_at, member_casual
    FROM
        all_data
    WHERE
        ride_id NOT IN (SELECT 
                ride_id
            FROM
                clean_data_1
            WHERE
                0 > ended_at - started_at));

-- また、分析にはさらに2つの項目（使用時間と曜日）があれば便利かと思いますので、作成していきます。
WITH member_type AS (
	SELECT membercasual AS Member
    FROM clean_data_1),

	day_of_week AS (
    SELECT ride_id, started_at,
		CASE DATE_FORMAT(started_at, '%w')
            WHEN 0 THEN 'Sun'
			WHEN 1 THEN 'Mon' 
			WHEN 2 THEN 'Tue' 
			WHEN 3 THEN 'Wed' 
            WHEN 4 THEN 'Thu' 
            WHEN 5 THEN 'Fri' 
			WHEN 6 THEN 'Sat' 
            ELSE 'x' 
		END AS d_of_week
	FROM clean_data),

	m_final_data AS (
    SELECT cd.ride_id,
		cd.started_at,
        ended_at,
        dw.d_of_week,
        rl.m_ride,
        rl.m_time_diff,
        start_lat,
        start_lng,
        end_lat,
        end_lng,
        member_casual
	FROM clean_data cd
    JOIN ride_length rl ON cd.ride_id = rl.ride_id
    JOIN day_of_week dw ON cd.ride_id = dw.ride_id)
SELECT * FROM m_final_data
WHERE member_casual = 'member';

-- ここで、Tableauでも実は同じ作業ができることに気づきましたので、この作業はTableau上で実施することとしました。
-- ここからはTableauでのデータ可視化になります。
