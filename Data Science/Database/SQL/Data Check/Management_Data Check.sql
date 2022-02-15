SELECT DISTINCT ym_magam
FROM DATAMART_DHDT_TOTAL DDT
ORDER BY ym_magam DESC

SELECT *
FROM DATAMART_DHDT_TOTAL DDT;
--- 업데이트: 매달 20일 4시?
--- 사용 영역: 카드 지표 전체, 카드 지표-`사업유형별 실적` 전체, `누적 매출`, `누적 매출이익률`, `누적 영업이익`, `누적 영업이익률`, `연간 손익`, `당기 누적 손익`-(`매출액`, `영업이익`), `주요 부문별 매출`, `주요 부문별 매출이익률`, `손익계산서`, `재무상태표`, `부채비율`, `차입금의존도`, `유동비율`, `이자보상배율`

--## 연도별 매출액, 매출원가, 판관비, 영업이익
SELECT yr, sales, sales_cost, fee, sales - sales_cost - fee AS profit
FROM (
	SELECT yr, ROUND(SUM(c1)/100000000, 0) AS sales, ROUND(SUM(c2)/100000000, 0) AS sales_cost, ROUND(SUM(c3)/100000000, 0) AS fee
	FROM (
		SELECT LEFT(ym_magam, 4) AS yr, CASE WHEN LEFT(cd_trial, 2) = '41' THEN am_account_wol END AS c1, CASE WHEN LEFT(cd_trial, 2) = '46' THEN am_account_wol END AS c2, CASE WHEN LEFT(cd_trial, 2) = '61' THEN am_account_wol END AS c3
		FROM DATAMART_DHDT_TOTAL DDT
		WHERE cd_dept_acnt = 'HD00') A
	GROUP BY yr) B;

--## 올해 누적 영업이익
SELECT ym_magam, SUM(sales) OVER(ORDER BY ym_magam ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), SUM(sales_cost) OVER(ORDER BY ym_magam ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), SUM(fee) OVER(ORDER BY ym_magam ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), SUM(sales - sales_cost - fee) OVER(ORDER BY ym_magam ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS profit
FROM (
	SELECT ym_magam, ROUND(SUM(c1)/100000000, 0) AS sales, ROUND(SUM(c2)/100000000, 0) AS sales_cost, ROUND(SUM(c3)/100000000, 0) AS fee
	FROM (
		SELECT ym_magam, CASE WHEN LEFT(cd_trial, 2) = '41' THEN am_account_wol END AS c1, CASE WHEN LEFT(cd_trial, 2) = '46' THEN am_account_wol END AS c2, CASE WHEN LEFT(cd_trial, 2) = '61' THEN am_account_wol END AS c3
		FROM DATAMART_DHDT_TOTAL DDT
		WHERE cd_dept_acnt = 'HD00' AND LEFT(ym_magam, 4) = 2021) A
	GROUP BY ym_magam) B
ORDER BY ym_magam;

--## 연도별 자산, 부채, 자본, 부채비율
SELECT *, prop - debt AS cap, ROUND(debt/(prop - debt)*100, 1) AS debt_ratio
FROM (
	SELECT ym_magam, ROUND(SUM(prop)/100000000, 0) AS prop, ROUND(SUM(debt)/100000000, 0) AS debt
	FROM (
		SELECT ym_magam, MAX(ym_magam) OVER(PARTITION BY LEFT(ym_magam, 4)) AS max_yr, CASE WHEN LEFT(cd_trial, 1) = '1' THEN am_account END AS prop, CASE WHEN LEFT(cd_trial, 1) = '2' THEN am_account END AS debt
		FROM DATAMART_DHDT_TOTAL DDT
		WHERE cd_dept_acnt = 'HD00') A
	WHERE ym_magam = max_yr
	GROUP BY ym_magam) B	
ORDER BY CAST(ym_magam AS INT);

SELECT *
FROM DATAMART_DHDT_ACNT_GROUP DDAG;
--- 업데이트: 매달 20일 4시?
--- 사용 영역:  카드 지표-`사업유형별 실적` 전체, `주요 부문별 매출`, `주요 부문별 매출이익률`

SELECT *
FROM DATAMART_DHDT_TOTAL_GROUP DDTG;
--- 업데이트: 매달 20일 4시?
--- 사용 영역: `주요 부문별 매출`, `주요 부문별 매출이익률`

--## 그룹, 연도별 매출
SELECT ds_group, LEFT(max_yr, 4) AS yr, sales
FROM (
	SELECT DDT.ym_magam, MAX(DDT.ym_magam) OVER(PARTITION BY LEFT(DDT.ym_magam, 4)) AS max_yr, DDTG.ds_group, ROUND(SUM(am_account_wol)/100000000, 0) AS sales
	FROM DATAMART_DHDT_TOTAL DDT INNER JOIN DATAMART_DHDT_ACNT_GROUP DDAG ON DDT.cd_corp = DDAG.cd_corp AND DDT.cd_dept_acnt = DDAG.cd_dept_acnt INNER JOIN DATAMART_DHDT_TOTAL_GROUP DDTG ON DDAG.cd_group = DDTG.cd_group
--	WHERE LEFT(DDT.cd_trial, 2) = '41' AND ds_group != '기타'
	-- 매출 원가
	WHERE LEFT(DDT.cd_trial, 2) = '46' AND ds_group != '기타'
	GROUP BY DDT.ym_magam, DDTG.ds_group) A
WHERE ym_magam = max_yr
ORDER BY ds_group, yr;

SELECT *
FROM DATAMART_DIFV_PL DDP;
--- 업데이트: 매달 20일 4시?
--- 사용 영역: `당기 누적 손익`-(`매출액 계획`, `영업이익 계획`)

--## 올해 누적 매출액 계획
SELECT MONTH, ROUND(SUM(pl) OVER(ORDER BY CAST(MONTH AS INT) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/100000000, 0)
FROM (
	SELECT MONTH, SUM(am_plan) AS pl
	FROM DATAMART_DIFV_PL DDP
	WHERE ds_item = '매출액' AND YEAR = 2021
	GROUP BY MONTH) AS A
ORDER BY CAST(MONTH AS INT);

--## 올해 누적 영업이익 계획
SELECT MONTH, ROUND(SUM(pl) OVER(ORDER BY CAST(MONTH AS INT) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/100000000, 0)
FROM (
	SELECT MONTH, SUM(am_plan) AS pl
	FROM DATAMART_DIFV_PL DDP
	WHERE ds_item = '영업이익' AND YEAR = 2021
	GROUP BY MONTH) AS A
ORDER BY CAST(MONTH AS INT);

--# 엑셀 파일-전사
--- 21.07~21.09 데이터만 있음. 이전 데이터는`DATAMART_DHDT_TOTAL`에 있음. 블렌딩 기능 사용
--- 사용 영역: 카드 지표(`경영 현황`),`누적 매출`,`누적 매출이익률`,`누적 영업이익`,`누적 영업이익률`,`연간 손익`,`당기 누적 손익`,`손익계산서`,`재무상태표`,`부채비율`,`차입금의존도`,`유동비율`,`이자보상배율`

--# 엑셀 파일-부문
--- DM과 블렌딩 x 엑셀만 단독으로 사용
--- 사용 영역: 카드 지표(`사업유형별 실적`),`주요 부문별 매출`,`주요 부문별 매출이익률`
