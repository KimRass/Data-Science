# 협업 필터링(Collaborative Filtering, CF)
## 1) 사용자 기반 추천 (User-based Recommendation)
- 나와 비슷한 성향을 지닌 사용자를 기반으로, 그 사람이 구매한 상품을 추천하는 방식입니다.
예를 들어 한 사용자가 온라인 몰에서 피자와 샐러드, 그리고 콜라를 함께 구매하고, 또 다른 사용자는 피자와 샐러드를 구매했다고 가정해보겠습니다. 알고리즘은 구매 목록이 겹치는 이 둘을 유사하다고 인식하고, 두 번째 사용자에게 콜라를 추천합니다.
## 2) 아이템 기반 추천 (Item-based Recommendation)
- 내가 이전에 구매했던 아이템을 기반으로, 그 상품과 유사한 다른 상품을 추천하는 방식입니다. 
상품 간 유사도는 함께 구매되는 경우의 빈도를 분석하여 측정합니다. 예를 들어 콜라와 사이다가 함께 구매되는 경우가 많다면 콜라를 구매한 사용자에게 사이다를 추천하는 것입니다.
## 한계
### 1) 콜드 스타트(Cold Start)
- 협업 필터링 알고리즘을 사용하기 위해 필수적인 요소를 눈치채셨나요? 바로 기존 데이터입니다. 
사용자 기반 추천방식만으로는 아무런 행동이 기록되지 않은 신규 사용자에게 어떠한 아이템도 추천할 수 없을 것입니다. 아이템 기반 추천방식에서도, 새로운 아이템이 출시되더라도 이를 추천할 수 있는 정보가 쌓일 때까지 추천이 어려워지겠죠.
콜드 스타트란 이러한 상황을 일컫는 말입니다. ‘새로 시작할 때의 곤란함’ 정도로 해석할 수 있습니다. 시스템이 아직 충분한 정보를 모으지 못한 사용자에 대한 추론을 이끌어낼 수 없는 문제입니다.
### 3) 롱테일(Long Tail), sparsity problem
- 롱테일은 파레토 법칙(전체 결과의 80%가 전체 원인의 20%에서 일어나는 현상)을 그래프로 나타내었을 때 꼬리처럼 긴 부분을 형성하는 80%의 부분을 일컫는 말입니다. 이 현상을 협업 필터링에 적용하면, 사용자들이 관심을 많이 보이는 소수의 콘텐츠가 전체 추천 콘텐츠로 보이는 비율이 높은 ‘비대칭적 쏠림 현상'이 발생한다는 의미입니다. 
아이템이나 콘텐츠의 수가 많다고 하더라도 사용자들은 소수의 인기 있는 항목에만 관심을 보이기 마련입니다. 따라서 사용자들의 관심이 저조한 항목은 정보가 부족하여 추천되지 못하는 문제점이 발생할 수 있습니다.
- <img src="https://t1.daumcdn.net/thumb/R1280x0.fpng/?fname=http://t1.daumcdn.net/brunch/service/user/16yJ/image/JKDg--QU_l-Byu2qXjutdGaZccU.png" height="360px">
## 알고리즘 분류
### memory based
- Memory based 알고리즘은 neighborhood model의 user based(user-oriented neighborhood model), Item based(item-oriented neighborhood model)로 나뉨.
- 메모리 기반 알고리즘(Neighborhood model 기준)은 유저와 아이템에 대한 matrix를 만든 뒤, 유저 기반 혹은 아이템 기반으로 유사한 객체를 찾은 뒤 빈공간을 추론하는 알고리즘이다.
- 먼저 Neighborhood model은 주어진 평점 데이터를 가지고 서로 비슷한 유저 혹은 아이템을 찾습니다. 이 때 유사도는 주로 Pearson 상관계수를 통해 구합니다.
### model based
- model based 알고리즘은 latent factor model 가운데 matrix factorization(MF), RBM, 베이지안 등으로 나뉨.
- Implicit Dataset이 주어질 경우, Latent Factor Model이 Neighborhood model 보다 뛰어난 성능을 보입니다.
- 반대로 item based CF의 경우, 어벤져스에 대해 내린 유저의 평가와 가장 유사한 레디플레이어원을 유사도 계산으로 찾아내어 빈공간을 메우는 것에 이용된다. 두 방법 모두 콜드 스타트 문제점을 안고있지만, item based CF가 Hybrid 방식을 적용하여 콜드 스타트 문제를 해결하기에 조금 더 능동적이다.
- 출처 : https://yamalab.tistory.com/69?category=747907
- 다음으로 모델 기반의 알고리즘에 대해 알아보자. 모델 기반의 알고리즘 중, 가장 널리 사용되는 MF만을 살펴보겠다. MF는 유저나 상품의 정보를 나타내는 벡터를 PCA나 SVD같은 알고리즘으로 분해하거나 축소하는 방법이다. 즉 Matrix Factorization은, 유저를 행으로 하고 상품에 대한 평가를 열로 하는 matrix가 있다고 할 때 이를 두 개의 행렬로 분해하는 방법으로, 유저에 대한 latent와 상품에 대한 latent를 추출해내는 것에 그 목적이 있다고 하겠다.
latent는 각각의 유저에 대한 특징을 나타내는 vector로, 머신이 이해하는 방법과 개수대로 생성해낸 것이다. latent vector 간의 distance를 이용하여 유사한 유저나 상품을 추천하는 것에 활용할 수 있다. (latent의 rank를 학습하는 알고리즘과 사용자 지정해주는 알고리즘으로 나뉜다) PCA의 에이겐 벡터 + 에이겐 벨류와 비슷한 개념이라고 생각하면 된다. 아래의 그림(Andrew Ng의 강의 슬라이드 발췌)을 보면 직관적으로 이해가 될 것이다.
MF의 가장 대표적인 방법은 SVD(Singular Value Decomposition)이다. 특이값 분해라고 하는데, 고유값 분해처럼 행렬을 대각화하여 분해하는 방법 중 하나이다. 고유값 분해와 다른 점은 nXn의 정방행렬이 아니어도 분해가 가능하다는 것이고, 이는 Sparse한 특성을 가지는 추천 시스템에서의 Matrix를 분해하는 것에 안성맞춤이다.
U는 AAT를 고유값분해해서 얻어진 직교행렬로 U의 열벡터들을 A의 left singular vector라 부르고, V 의 열벡터들을 A의 right singular vector라 부른다. 또한 Σ는 AAT, ATA를 고유값분해해서 나오는 고유값들의 square root를 대각원소로 하는 m x n 직사각 대각행렬로, 그 대각원소들을 A의 특이값(singular value)이라 부른다. 즉 U, V는 특이 벡터를 나타낸 행렬이고 Σ 는 특이값에 대한 행렬이라고 할 수 있다.
Σ의 크기를 지정해 줌으로써 latent(의미 부여 벡터)의 크기를 지정해 줄 수도 있다. 이후 decomposition 된 행렬들을 이용하여 원래의 행렬 A와 사이즈가 동일한 행렬을 만들어내면, 비어있는 공간들을 유추해내는 새로운 행렬이 나타나는 것이다. 이를 Matrix Completion의 관점에서 보면, A 행렬에서 rating이 존재하는 데이터를 이용해 미지의 U, Σ, V를 학습하여 Completed 된 행렬 A`를 만들어내는 것이다.
SVD를 비롯한 MF에서 목적함수는, Predicted rating을 구하는 Matrix Completion의 경우, 최적의 해(Rating – Predicted Rating의 최소)가 없이 근사값을 추론하는 문제이다. 따라서 Gradient Descent 알고리즘, ALS(Alternating Least Square) 알고리즘 등으로, global minimum에 근접하는 thresh를 선정하여 이를 objective로 삼아 구하는 문제로 볼 수 있다. 일반적으로는 GD가 우수하지만, ALS는 병렬 처리 환경에서 좋은 성능을 보인다고 알려져 있다.
참고 : 학습이 완료된 후 user나 item에 대한 입력값의 행렬 연산 결과를 prediction을 할 때, 예상을 해야하는 결측값(Matrix에서 *으로 표기된 부분)의 초기값은 binary로 보정하거나 평균 혹은 중앙값으로 보정하기도 한다.
그래서 일반적으로 CF 기반의 추천 시스템을 구축할 때, 가장 많이 사용하는 알고리즘 스택은 SVD, 혹은 ALS를 기반으로 한 Hybrid 방법이 많다
# contents-based filtering
- 콘텐츠 기반 필터링은 말 그대로 콘텐츠에 대한 분석을 기반으로 추천하는 방식입니다.
영화 콘텐츠의 경우라면 스토리나 등장인물을, 상품이라면 상세 페이지의 상품 설명을 분석합니다. 
콘텐츠 기반 필터링의 장점은 많은 양의 사용자 행동 정보가 필요하지 않아 콜드 스타트 문제점이 없다는 것입니다. 아이템과 사용자 간의 행동을 분석하는 것이 아니라 콘텐츠 자체를 분석하기 때문입니다.
##  '메타 정보의 한정성'입니다.
- 상품의 프로파일을 모두 함축하는 데에 한계가 있다는 점입니다.
쉬운 설명을 위해 BTS의 또 다른 팬 T군이 있다고 가정해보겠습니다. T군은 BTS 중에서도 특히 정국이라는 멤버를 좋아하여, 그와 관련 있는 신문 기사를 주로 찾아보았습니다. 
하지만 기사 내용만으로 콘텐츠를 분류해야 하는 신문사 알고리즘 입장에서는, T군의 성향을 세부적으로 파악하기가 어렵습니다. BTS 전체의 기사 텍스트와 BTS 중 한 명의 멤버에 대한 기사 텍스트에서 큰 차이가 없기 때문입니다. 여기서 콘텐츠 기반 필터링의 정밀성이 떨어지는 문제가 발생합니다.
# hybrid recommender systems
- 하이브리드 추천 시스템은 협업 필터링과 콘텐츠 기반 필터링을 조합하여 상호 보완적으로 개발된 알고리즘입니다. 협업 필터링의 콜드 스타트 문제 해결을 위해 신규 콘텐츠는 콘텐츠 기반 필터링 기술로 분석하여 추천하고, 충분한 데이터가 쌓인 후부터는 협업 필터링으로 추천의 정확성을 높이는 방식입니다.
# machine learning recommender systems
- 머신러닝의 학습으로 추천하는 방식도 많이 개발되고 있습니다. 사용자에게 추천할 후보군을 먼저 보여주고 기계가 그에 대한 사용자 반응을 학습하며 점점 더 정교한 결과를 도출해내는 방식입니다.
## information utilization problem
- 다음으로, 영화 추천이나 맛집 추천 서비스가 아닌 대부분의 추천 서비스에서 나타나는 문제점인 Information Utilization Problem이 있다. 이는 추천 시스템 구축에 활용하기 위한 데이터, 정보들을 올바르게 활용하기 위한 고민에서 나온 문제점이라고 할 수 있다. 이를 이해하기 위해 e-commere에서의 추천 시스템에서 고객의 행동을 생각해보자. 대부분의 고객들은 상품을 눌러보고, 다른 상품도 살펴보고, 본인 기준에 마음에 든다면 장바구니에 넣어뒀다가 이를 구매하기도 한다. 이런 정보들을 Implicit Score(암묵 점수)라고 한다. 
왓챠나 넷플릭스 같은 영화 추천 서비스에서처럼, 사용자들은 아이템에 대한 명확한 평가를 내리지 않는다. 단지 상품을 눌러보고, 관심 표시를 하거나 구매 하는 정도이다. 상품에 대한 리뷰를 작성하거나 별점을 주는 고객은 극소수에 가깝다. 이러한 로그 데이터 속에 숨어있는 정보를 이용하는 고민이 필요하다. 하지만 이것이 쉽지 않기 때문에 Information Utilization Problem 이라고 부르는 것이다. 만약 고객의 구매 목록 데이터가 있을 때, 구매가 완료되었다고 과연 이 데이터가 상품에 대한 호감을 나타내는 데이터라고 할 수 있을까? 환불이나 교환이 일어났다면? 이 모든 것을 고려하여 데이터를 활용하기 용이한 Explicit Score(명시 점수 : 영화 평점에 대한 rating 같은 점수)처럼 데이터를 Utilization 하는 과정이 필요할 것이다.
그렇다고 Explicit Score가 항상 좋은 데이터인 것은 아니다. 대부분의 잘 정리된 명시 점수의 경우 Sparsity Problem을 심각하게 겪을 것이다.
## association rule
- Association Rule은 고객들의 상품 묶음 정보를 규칙으로 표현하는 가장 기본적인 알고리즘이다. 흔히 장바구니 분석이라고도 불린다. 데이터마이닝 같은 수업을 들었다면 한번 쯤 들어봤을 법한 알고리즘이다. 이 알고리즘은 기초적인 확률론에 기반한 방법으로, 전체 상품중에 고객이 함께 주문한 내역을 살펴본 뒤 상품간의 연관성을 수치화하여 나타내는 알고리즘이다. 매우 직관적이고 구현하기도 쉽지만, 그렇다고 현재로서 성능이 매우 떨어지는 알고리즘도 아니다. 추천 시스템에서 여전히 가장 중요한 알고리즘으로 분류되며 Association Rule에서 파생된 다양한 알고리즘들이 존재한다.
- 출처 : https://yamalab.tistory.com/86?category=747907
## 분류
- 추천의 타입은 크게 3가지로 분류된다. 먼저 유저의 정보에 기반하여 자동으로 아이템 리스트를 추려주는 Personalized recommender(개인화 추천), 그리고 rating 기반의 인기 상품이나 현재 상품 기준 AR(Association Rule. 이하 AR) 순위 상품을 추천해주는 Non-personalized recommender 방법이 있다. 이 방법은 주로 Cold Start Problem(개인화 추천 모델링을 위한 유저정보 혹은 아이템 정보가 부족한 상황)이 발생하는 상황이나 개인화추천이 잘 적용되지 않는 추천 영역에 사용된다. 그리고 마지막으로 Attribute-based recommender 방법이 있다. 아이템 자체가 가지고 있는 정보, 즉 Contents 정보를 활용하여 추천하는 방법으로 Cold Start 문제를 해결하는 조금 더 세련된 방법이라고 할 수 있다. 뒤에 설명할 CF(Collaborative Filtering. 이하 CF)와 상호 보완적인 알고리즘인 Content-based approach 라고도 불린다.
위의 세 가지 타입에 매칭되는 대표적인 알고리즘은 Personalized recommender - CF, Non-personalized recommender - AR, Attribute-based recommender - Content based approach 라고 할 수 있다. 
# evaluation metrics
## MAP(Mean Average Precision)
- 하지만 사용자에 따라서 실제로 소비한 아이템의 수가 천 개, 2천개까지 늘어날 수 있습니다. 이 경우 recall이 1이 되는 지점까지 고려하는 것은 무리이므로 최대 n개까지만 고려하여 mAP를 계산하며, 이 경우 mAP@n 으로 표기합니다.
## nDCG(normalized Discounted Cumulative Gain)
- 추천 엔진은 기본적으로 각 아이템에 대해서 사용자가 얼마나 선호할 지를 평가하며, 이 스코어 값을 relevance score라고 부릅니다. 그리고 이 relevance score 값들의 총 합을 Cumulative Gain(CG)라고 부릅니다. 먼저 위치한 relavance score가 CG에 더 많은 영향을 줄 수 있도록 할인의 개념을 도입한 것이 Discounted Cumulative Gain(DCG)입니다.
- <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https://blog.kakaocdn.net/dn/dikjW1/btqDvgFUh3K/GdjWcm9XS4zpqECsQx9Nu1/img.png" height="80px">
- 하루에 100개의 동영상을 소비하는 사용자와 10개의 동영상을 소비하는 사용자에게 제공되는 추천 아이템의 개수는 다를 수 밖에 없습니다. 이 경우 추천 아이템의 개수를 딱 정해놓고 DCG를 구하여 비교할 경우 제대로 된 성능 평가를 진행할 수 없습니다. 때문에 DCG에 정규화를 적용한 NDCG(normalized discounted cumulative gain)이 제안됩니다. NDCG를 구하기 위해서는 먼저 DCG와 함께 추가적으로 iDCG를 구해주어야 합니다. iDCG의 i는 ideal을 의미하며 가장 이상적으로 relavace score를 구한 것을 말합니다. NDCG는 DCG를 iDCG로 나누어 준 값으로 0에서 1 사이의 값을 가지게 됩니다.
- <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https://blog.kakaocdn.net/dn/r9q0s/btqDxJzAlCa/Pccibd37tTjavu1QBeMZeK/img.png" height="200px">
## entropy diversity
- 그런데 아직 전체 아이템에서 얼마나 다양하게 추천을 진행했는지는 평가하지 못했습니다. Entropy Diversity는 추천 결과가 얼마나 분산 되어 있느냐를 평가하는 지표입니다.
- Entropy는 섀넌의 정보 이론에서 등장한 개념으로 머신러닝에서도 많이 사용됩니다. 간략하게 설명하면 잘 일어나지 않는 사건의 정보량은 잘 일어나는 사건의 정보량보다 많다는 것입니다. 이를 사건이 일어날 확률에 로그를 씌워서 정보량을 표현하며 로그의 밑의 경우 자연 상수를 취해줍니다. (다른 상수도 가능하긴 합니다.)
- <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https://blog.kakaocdn.net/dn/bOwzN3/btqDxt4UBcd/s0Kx6WWXyITuoKXaSZMAsk/img.png" height="250px">
- entropy란 발생할 수 있는 모든 사건들의 정보량의 기대 값입니다.
- <img src="https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=https://blog.kakaocdn.net/dn/sXcph/btqDwdoeBsv/IjVthd4jsDV0jt3p6MCfT0/img.png" height="70px">
- Entropy Diversity란 이러한 엔트로피의 개념을 추천 결과에 적용한 것입니다. 모든 사용자들에게 비슷한 종류의 상품을 추천할 경우 해당 상품 추천은 자주 발생하므로 정보량이 낮습니다. 반면 개인에게 맞춤화 된 추천은 발생 횟수가 적으므로 정보량이 높아집니다. 이들의 기대값을 구한 것이 바로 Entropy Diversity입니다.
- 그러나 Entropy Diversity 만으로 추천 엔진이 더 정확하다고 평가할 수 는 없습니다. 어디까지나 추천 결과의 다양성을 측정하는 지표이므로 mAP나 NDCG처럼 정확도를 측정할 수 있는 지표와 함께 사용하는 것이 바람직해 보입니다.
