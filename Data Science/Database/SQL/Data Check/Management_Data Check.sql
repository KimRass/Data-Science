SELECT DISTINCT ym_magam
FROM DATAMART_DHDT_TOTAL DDT
ORDER BY ym_magam DESC

SELECT *
FROM DATAMART_DHDT_TOTAL DDT;
--- ������Ʈ: �Ŵ� 20�� 4��?
--- ��� ����: ī�� ��ǥ ��ü, ī�� ��ǥ-`��������� ����` ��ü, `���� ����`, `���� ����������`, `���� ��������`, `���� ����������`, `���� ����`, `��� ���� ����`-(`�����`, `��������`), `�ֿ� �ι��� ����`, `�ֿ� �ι��� ����������`, `���Ͱ�꼭`, `�繫����ǥ`, `��ä����`, `���Ա�������`, `��������`, `���ں������`
-- ����: LEFT(cd_trial, 2) = '41'
-- �������: LEFT(cd_trial, 2) = '46'
-- �ǰ���: LEFT(cd_trial, 2) = '61'
-- ��������: ���� - ������� - �ǰ���
-- ��������: ���� - �������
-- ��ä: LEFT(cd_trial, 1) = '2'
-- �ڻ�: LEFT(cd_trial, 1) = '1'
-- �ں�: �ڻ� - ��ä
-- ��ä����: ��ä/�ں�
-- ���Ա�: cd_trial IN('22101101', '22201101', '22101102', '22201201', '22301101', '22301201', '27101101', '27101102', '27101104', '27101201', '27301101', '27301201', '22101100', '22201100', '27101100')
-- ���Ա�������: ���Ա�/�ڻ�
-- �����ڻ�: LEFT(cd_trial, 2) IN('11', '12', '14')
-- ������ä: LEFT(cd_trial, 2) IN('21', '22', '23')
-- ��������: �����ڻ�/������ä
-- ���ں��: LEFT(cd_trial, 6) = '716011'
-- ���ں������: ��������/���ں��
-- �����ܼ���: (71103101 <= CAST(cd_trial AS INT) AND CAST(cd_trial AS INT) <= 71109901)
-- �����ܺ��: (71603101 <= CAST(cd_trial AS INT) AND CAST(cd_trial AS INT) <= 71609901)
-- ��������: (71101100 <= CAST(cd_trial AS INT) AND CAST(cd_trial AS INT) <= 71102201)
-- �������: (71601100 <= CAST(cd_trial AS INT) AND CAST(cd_trial AS INT) <= 71602201)
-- ��Ÿ�����ܼ���: (71907008 <= CAST(cd_trial AS INT) AND CAST(cd_trial AS INT) <= 71907609)
-- ��������: �������� + �����ܼ��� - �����ܺ�� + �������� - ������� + ��Ÿ�����ܼ���

--## ������ �����, �������, �ǰ���, ��������
SELECT yr, sales, sales_cost, fee, sales - sales_cost - fee AS profit
FROM (
	SELECT yr, ROUND(SUM(c1)/100000000, 0) AS sales, ROUND(SUM(c2)/100000000, 0) AS sales_cost, ROUND(SUM(c3)/100000000, 0) AS fee
	FROM (
		SELECT LEFT(ym_magam, 4) AS yr, CASE WHEN LEFT(cd_trial, 2) = '41' THEN am_account_wol END AS c1, CASE WHEN LEFT(cd_trial, 2) = '46' THEN am_account_wol END AS c2, CASE WHEN LEFT(cd_trial, 2) = '61' THEN am_account_wol END AS c3
		FROM DATAMART_DHDT_TOTAL DDT
		WHERE cd_dept_acnt = 'HD00') A
	GROUP BY yr) B;

--## ������ �� ���� ���� ����
SELECT ym_magam, SUM(am_account)
FROM DATAMART_DHDT_TOTAL DDT
WHERE cd_dept_acnt = 'HD00'
	AND LEFT(cd_trial, 2) = '41'
GROUP BY ym_magam
ORDER BY ym_magam

--## ������ �ڻ�, ��ä, �ں�, ��ä����
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
FROM DATAMART_DHDT_ACNT_GROUP DDAG
WHERE cd_dept_acnt LIKE '%L%';

SELECT *
FROM DATAMART_DHDT_ACNT_GROUP DDAG;
--- ������Ʈ: �Ŵ� 20�� 4��?
--- ��� ����:  ī�� ��ǥ-`��������� ����` ��ü, `�ֿ� �ι��� ����`, `�ֿ� �ι��� ����������`

SELECT *
FROM DATAMART_DHDT_TOTAL_GROUP DDTG;
--- ������Ʈ: �Ŵ� 20�� 4��?
--- ��� ����: `�ֿ� �ι��� ����`, `�ֿ� �ι��� ����������`

SELECT DDT.ym_magam, MAX(DDT.ym_magam) OVER(PARTITION BY LEFT(DDT.ym_magam, 4)) AS max_yr, DDTG.ds_group, ROUND(SUM(am_account_wol)/100000000, 0) AS sales
FROM DATAMART_DHDT_TOTAL DDT LEFT OUTER JOIN DATAMART_DHDT_ACNT_GROUP DDAG ON DDT.cd_corp = DDAG.cd_corp AND DDT.cd_dept_acnt = DDAG.cd_dept_acnt LEFT OUTER JOIN DATAMART_DHDT_TOTAL_GROUP DDTG ON DDAG.cd_group = DDTG.cd_group
WHERE LEFT(DDT.cd_trial, 2) = '41' AND ds_group != '��Ÿ' AND LEFT(ym_magam, 4) = '2021' AND ds_group = '������'
GROUP BY DDT.ym_magam, DDTG.ds_group

--## �׷�, ������ ����
SELECT ds_group, LEFT(max_yr, 4) AS yr, SUM(sales) AS value
FROM (
	SELECT DDT.ym_magam, MAX(DDT.ym_magam) OVER(PARTITION BY LEFT(DDT.ym_magam, 4)) AS max_yr, DDTG.ds_group, ROUND(SUM(am_account_wol)/100000000, 0) AS sales
	FROM DATAMART_DHDT_TOTAL DDT
		LEFT OUTER JOIN DATAMART_DHDT_ACNT_GROUP DDAG ON DDT.cd_corp = DDAG.cd_corp AND DDT.cd_dept_acnt = DDAG.cd_dept_acnt
		LEFT OUTER JOIN DATAMART_DHDT_TOTAL_GROUP DDTG ON DDAG.cd_group = DDTG.cd_group
	WHERE ds_group != '��Ÿ'
		AND LEFT(DDT.cd_trial, 2) = '41'
	GROUP BY DDT.ym_magam, DDTG.ds_group) A
GROUP BY ds_group, max_yr
ORDER BY ds_group, LEFT(max_yr, 4);

SELECT *
FROM DATAMART_DIFV_PL DDP;
--- ������Ʈ: �Ŵ� 20�� 4��?
--- ��� ����: `��� ���� ����`-(`����� ��ȹ`, `�������� ��ȹ`)

--## ���� ���� ���� ����� ��ȹ
SELECT MONTH, ROUND(SUM(pl) OVER(ORDER BY CAST(MONTH AS INT) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/100000000, 0)
FROM (
	SELECT MONTH, SUM(am_plan) AS pl
	FROM DATAMART_DIFV_PL DDP
	WHERE ds_item = '�����' AND YEAR = 2021
	GROUP BY MONTH) AS A
ORDER BY CAST(MONTH AS INT);

--## ���� ���� ���� �������� ��ȹ
SELECT MONTH, ROUND(SUM(pl) OVER(ORDER BY CAST(MONTH AS INT) ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)/100000000, 0)
FROM (
	SELECT MONTH, SUM(am_plan) AS pl
	FROM DATAMART_DIFV_PL DDP
	WHERE ds_item = '��������' AND YEAR = 2021
	GROUP BY MONTH) AS A
ORDER BY CAST(MONTH AS INT);

--# ���� ����-����
--- 21.07~21.09 �����͸� ����. ���� �����ʹ�`DATAMART_DHDT_TOTAL`�� ����. ���� ��� ���
--- ��� ����: ī�� ��ǥ(`�濵 ��Ȳ`),`���� ����`,`���� ����������`,`���� ��������`,`���� ����������`,`���� ����`,`��� ���� ����`,`���Ͱ�꼭`,`�繫����ǥ`,`��ä����`,`���Ա�������`,`��������`,`���ں������`

--# ���� ����-�ι�
--- DM�� ���� x ������ �ܵ����� ���
--- ��� ����: ī�� ��ǥ(`��������� ����`),`�ֿ� �ι��� ����`,`�ֿ� �ι��� ����������`
