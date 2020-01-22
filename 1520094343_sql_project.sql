/* Welcome to the SQL mini project. For this project, you will use
Springboard' online SQL platform, which you can log into through the
following link:

https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

Note that, if you need to, you can also download these tables locally.

In the mini project, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */

/* ========================================================================
Q1: Some of the facilities charge a fee to members, but some do not.
Please list the names of the facilities that do. */



----------CODE----------
SELECT 	name,
	membercost
FROM Facilities
WHERE membercost != 0



/* ----------ANSWER----------
name			membercost
Tennis Court 1		5.0
Tennis Court 2		5.0
Massage Room 1		9.9
Massage Room 2		9.9
Squash Court		3.5
*/


/* ========================================================================
Q2: How many facilities do not charge a fee to members? */



----------CODE----------
SELECT 	COUNT(*) AS number_of_facilities_not_charging
FROM Facilities
WHERE membercost = 0



/* ----------ANSWER----------
number_of_facilities_not_charging
				4
*/


/* ========================================================================
Q3: How can you produce a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost?
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */



----------CODE----------
SELECT  facid,
	name,
	membercost,
	monthlymaintenance
FROM Facilities
WHERE membercost < (monthlymaintenance * 0.2)



/* ----------ANSWER----------
facid	name		membercost	monthlymaintenance
0	Tennis Court 1	5.0		200
1	Tennis Court 2	5.0		200
2	Badminton Court	0.0		50
3	Table Tennis	0.0		10
4	Massage Room 1	9.9		3000
5	Massage Room 2	9.9		3000
6	Squash Court	3.5		80
7	Snooker Table	0.0		15
8	Pool Table	0.0		15
*/


/* ========================================================================
Q4: How can you retrieve the details of facilities with ID 1 and 5?
Write the query without using the OR operator. */



----------CODE----------
SELECT  *
FROM Facilities
WHERE facid IN (1, 5)



/* ----------ANSWER----------
facid	name		membercost	guestcost	initialoutlay	monthlymaintenance
1	Tennis Court 2	5.0		25.0		8000		200
5	Massage Room 2	9.9		80.0		4000		3000
*/


/* ========================================================================
Q5: How can you produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100? Return the name and monthly maintenance of the facilities
in question. */



----------CODE----------
SELECT 	name,
	monthlymaintenance,
	CASE WHEN monthlymaintenance <= 100
		THEN 'cheap'
		ELSE 'expensive'
	END AS cheap_or_expensive
FROM Facilities



/* ----------ANSWER----------
name		monthlymaintenance	cheap_or_expensive
Tennis Court 1	200			expensive
Tennis Court 2	200			expensive
Badminton Court	50			cheap
Table Tennis	10			cheap
Massage Room 1	3000			expensive
Massage Room 2	3000			expensive
Squash Court	80			cheap
Snooker Table	15			cheap
Pool Table	15			cheap
*/


/* ========================================================================
Q6: You'd like to get the first and last name of the last member(s)
who signed up. Do not use the LIMIT clause for your solution. */



----------CODE----------
SELECT  surname, 
	firstname
	FROM Members
	WHERE joindate = (
		SELECT MAX( joindate )
		FROM Members )



/* ----------ANSWER----------
surname firstname
Smith	Darren
*/


/* ========================================================================
Q7: How can you produce a list of all members who have used a tennis court?
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */



----------CODE----------
SELECT 	DISTINCT(CONCAT(m.firstname, ' ', m.surname)) AS fullname,
	f.name
FROM 	Facilities f,
	Members m,
	Bookings b
WHERE 	m.memid = b.memid
	AND b.facid = f.facid
	AND (f.facid = 0 OR f.facid = 1)
ORDER BY fullname



/* ----------ANSWER----------
fullname		name	
Anne Baker		Tennis Court 1
Anne Baker		Tennis Court 2
Burton Tracy		Tennis Court 1
Burton Tracy		Tennis Court 2
Charles Owen		Tennis Court 1
Charles Owen		Tennis Court 2
Darren Smith		Tennis Court 2
David Farrell		Tennis Court 1
David Farrell		Tennis Court 2
David Jones		Tennis Court 1
David Jones		Tennis Court 2
David Pinker		Tennis Court 1
Douglas Jones		Tennis Court 1
Erica Crumpet		Tennis Court 1
Florence Bader		Tennis Court 2
Florence Bader		Tennis Court 1
Gerald Butters		Tennis Court 1
Gerald Butters		Tennis Court 2
GUEST GUEST		Tennis Court 2
GUEST GUEST		Tennis Court 1
Henrietta Rumney	Tennis Court 2
Jack Smith		Tennis Court 2
Jack Smith		Tennis Court 1
Janice Joplette		Tennis Court 1
Janice Joplette		Tennis Court 2
Jemima Farrell		Tennis Court 1
Jemima Farrell		Tennis Court 2
Joan Coplin		Tennis Court 1
John Hunt		Tennis Court 1
John Hunt		Tennis Court 2
Matthew Genting		Tennis Court 1
Millicent Purview	Tennis Court 2
Nancy Dare		Tennis Court 2
Nancy Dare		Tennis Court 1
Ponder Stibbons		Tennis Court 1
Ponder Stibbons		Tennis Court 2
Ramnaresh Sarwin	Tennis Court 2
Ramnaresh Sarwin	Tennis Court 1
Tim Boothe		Tennis Court 1
Tim Boothe		Tennis Court 2
Tim Rownam		Tennis Court 2
Tim Rownam		Tennis Court 1
Timothy Baker		Tennis Court 2
Timothy Baker		Tennis Court 1
Tracy Smith		Tennis Court 2
Tracy Smith		Tennis Court 1
*/


/* ========================================================================
Q8: How can you produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30? Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */



----------CODE----------
SELECT  CONCAT(m.firstname, ' ', m.surname) AS fullname,
	b.starttime,
	CASE WHEN m.memid = 0 THEN (f.guestcost * b.slots)
	     ELSE (f.membercost * b.slots)
	END AS cost,
	f.name

FROM 	Members m
LEFT JOIN Bookings b
ON m.memid = b.memid
LEFT JOIN Facilities f
ON b.facid = f.facid

WHERE b.starttime LIKE '2012-09-14%'
AND IF(m.memid =0, f.guestcost, f.membercost) * b.slots > 30

ORDER BY cost DESC



/* ----------ANSWER----------
fullname	starttime		cost	name	
GUEST GUEST	2012-09-14 11:00:00	320.0	Massage Room 2
GUEST GUEST	2012-09-14 16:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 13:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 09:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 17:00:00	150.0	Tennis Court 2
GUEST GUEST	2012-09-14 14:00:00	75.0	Tennis Court 2
GUEST GUEST	2012-09-14 19:00:00	75.0	Tennis Court 1
GUEST GUEST	2012-09-14 16:00:00	75.0	Tennis Court 1
GUEST GUEST	2012-09-14 09:30:00	70.0	Squash Court
Jemima Farrell	2012-09-14 14:00:00	39.6	Massage Room 1
GUEST GUEST	2012-09-14 15:00:00	35.0	Squash Court
GUEST GUEST	2012-09-14 12:30:00	35.0	Squash Court
*/


/* ========================================================================
Q9: This time, produce the same result as in Q8, but using a subquery. */



----------CODE----------
SELECT  *
FROM	(
	SELECT 	CONCAT(m.firstname, ' ', m.surname) AS fullname,
		b.starttime,
		CASE WHEN m.memid = 0 THEN (f.guestcost * b.slots)
	     		ELSE (f.membercost * b.slots)
		END AS cost,
		f.name
	FROM 	Members m
	LEFT JOIN Bookings b
	ON m.memid = b.memid
	LEFT JOIN Facilities f
	ON b.facid = f.facid
	WHERE b.starttime LIKE '2012-09-14%'
	AND IF(m.memid =0, f.guestcost, f.membercost) * b.slots > 30
	ORDER BY cost DESC	
	) AS squery



/* ----------ANSWER----------
fullname	starttime		cost	name	
GUEST GUEST	2012-09-14 11:00:00	320.0	Massage Room 2
GUEST GUEST	2012-09-14 16:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 13:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 09:00:00	160.0	Massage Room 1
GUEST GUEST	2012-09-14 17:00:00	150.0	Tennis Court 2
GUEST GUEST	2012-09-14 14:00:00	75.0	Tennis Court 2
GUEST GUEST	2012-09-14 19:00:00	75.0	Tennis Court 1
GUEST GUEST	2012-09-14 16:00:00	75.0	Tennis Court 1
GUEST GUEST	2012-09-14 09:30:00	70.0	Squash Court
Jemima Farrell	2012-09-14 14:00:00	39.6	Massage Room 1
GUEST GUEST	2012-09-14 15:00:00	35.0	Squash Court
GUEST GUEST	2012-09-14 12:30:00	35.0	Squash Court
*/


/* ========================================================================
Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */


----------CODE----------
SELECT 	DISTINCT(f.name),
	SUM(CASE WHEN b.memid = 0 THEN (f.guestcost * b.slots)
		ELSE (f.membercost * b.slots)
	END) AS revenue

FROM	Facilities f 	
LEFT JOIN Bookings b
ON b.facid = f.facid

GROUP BY f.name
HAVING revenue < 1000
ORDER BY revenue DESC



/* ----------ANSWER----------
name		revenue	
Pool Table	270.0
Snooker Table	240.0
Table Tennis	180.0
*/