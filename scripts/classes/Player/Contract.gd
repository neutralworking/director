Club = FOREIGN KEY Club
Job = FOREIGN KEY Job
Secondary Job = FOREIGN KEY Job
Date Joined = DATE
Date Signed Last Contract = DATE
Contract Expires = DATE
Contract Type = FOREIGN KEY Contract Type (Full Time, Part Time, Amateur, Youth, Non-Contract, Future Professional, Generation Adidas (USA), Senior Minimum Salary (USA), Reserve (USA), Designated Player (USA), Marquee Player (Australia), Australian Marquee Player (Australia), Junior Marquee Player (Australia), Guest Player (Australia))
Wages (per week) = NUM
On Rolling Contract = BOOL
Squad Number = NUM
Preferred Squad Number = NUM
Agent = FOREIGN KEY Agent


Contract Clauses
Appearance Bonus = NUM
Goal Bonus = NUM
Clean Sheet Bonus = NUM
Team Of The Season Award Payment = NUM
Unused Substitute Fee = NUM
Top Goalscorer Bonus (Division) = NUM
International Cap Bonus = NUM
Promotion Wage Increase = NUM
Relegation Wage Drop = NUM
Top Division Promotion Wage Rise = NUM
Top Division Relegation Wage Drop = NUM
Yearly Wage Increase = NUM
Minimum Fee Release = NUM
Foreign Club Release Fee = NUM
Domestic Club Release Fee = NUM
High Division Club Release Fee = NUM
Major Continental Competition Club Release Fee = NUM
Relegation Release Fee = NUM
Non Promotion Release Fee = NUM
Selling On Fee Percentage = NUM
Selling On Gee Percentage Of Profit = NUM
Seasonal Landmark Goal Bonus = NUM
One-Year Extension After League Games (Final Season)
One-Year Extension After League Games (Promoted Final Season)
One-Year Extension After League Games (Avoiding Relegation Final Season)
Optional Contract Extension By Club
Contract Extension After Promotion
Wage After Number League Games (per week)
Wage After International Caps (per week)
Percentage Of Compensation For Managerial Role = NUM
Match Highest Earner = BOOL
Injury Release Clause = BOOL
Non-Playing Job Offer Release Clause = BOOL
Waive Compensation For Managerial Role = BOOL
Will Leave At End Of Contract = BOOL

Competition Bonuses

Competition / Ranking / Stage Name / Sub Stage Name

Loan

Club = FOREIGN KEY Club
Start Date = DATE
End Date = DATE
Can Be Recalled = BOOL
Squad Number = NUM
Fee To Buy = NUM
& Wages Paid By Loaning Club = NUM
Monthly Fee = NUM

Future Transfer

Club = FOREIGN KEY = Club
Transfer Date = DATE
Contract End Date = DATE
Transfer Fee = NUM
Wage (per week) = NUM
New Job = PRIMARY KEY Job

Contract Clauses

Appearance Bonus - NUM
Goal Bonus = NUM
Clean Sheet Bonus = NUM
Promotion Wage Increase = NUM
Yearly Wage Increase = NUM
Minimum Fee Release = NUM
Relegation Release Fee = NUM
Non Promotion Release Fee = NUM
Will Leave At End Of Contract = NUM

Transfer Clauses

Next Sale Percentage = NUM
Fee After International Appearances - Number of Matches = NUM
Fee After International Appearances - Cash
Fee After League Appearances - Number Of Matches
Fee After League Appearances - Cash
Fee Per League Appearances - Max Matches
Fee Per League Appearances - Cash
Monthly Installments = Number Of Months
Monthly Installments - Cash 
Buy Back Cash
