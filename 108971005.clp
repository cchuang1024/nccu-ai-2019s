;; 資料:

(deftemplate course
    (slot course-id)
    (multislot teacher-id)
    (multislot pre-cond))

(deffacts courses
    (course (course-id C100)
            (teacher-id P007)
            (pre-cond NONE))
    (course (course-id C101)
            (teacher-id P007)
            (pre-cond C100))
    (course (course-id C102)
            (teacher-id P004)
            (pre-cond NONE))
    (course (course-id C103)
            (teacher-id P004)
            (pre-cond C102 C100))
    (course (course-id C104)
            (teacher-id P008)
            (pre-cond NONE))
    (course (course-id C105)
            (teacher-id P009)
            (pre-cond C104))
    (course (course-id C106)
            (teacher-id P003)
            (pre-cond C103 C101))
    (course (course-id C107)
            (teacher-id P007)
            (pre-cond C103))
    (course (course-id C108)
            (teacher-id P010)
            (pre-cond C103))
    (course (course-id C109)
            (teacher-id P003)
            (pre-cond C106))
    (course (course-id C110)
            (teacher-id P001)
            (pre-cond C106))
    (course (course-id C111)
            (teacher-id P002)
            (pre-cond NONE))
    (course (course-id C112)
            (teacher-id P004 P011)
            (pre-cond C111))
    (course (course-id C113)
            (teacher-id P005)
            (pre-cond C112))
    (course (course-id C114)
            (teacher-id P006)
            (pre-cond C110 C109))
    (course (course-id C115)
            (teacher-id P001)
            (pre-cond C105 C110))
    (course (course-id C116)
            (teacher-id P001)
            (pre-cond C103 C115)))

;; 第一題：

(defrule expand-tids
    ?g <- (givenby $?tids)
=>
    (progn$ (?tid $?tids)
        (assert (search-tid ?tid INIT)))
    (retract ?g))

(defrule fix-tid
    (not (fix-tid ?tid))
    (search-tid ?tid INIT)
=>
    (assert (fix-tid ?tid)))

(defrule search-by-teacher
    (fix-tid ?tid)
    (course (teacher-id ?tid $?)
            (course-id ?cid))
=>
    (assert (search-tid ?tid ?cid INIT)))

(defrule display-tid-hint
    (fix-tid ?tid)
    (not (hint-tid ?tid))
    (search-tid ?tid INIT)
=>
    (printout t "a teacher " ?tid " has taught courses: " crlf)
    (assert (hint-tid ?tid)))

(defrule display-courses
    (fix-tid ?tid)
    (hint-tid ?tid)
    (search-tid ?tid INIT)
    ?c <- (search-tid ?tid ?cid INIT)
=>
    (printout t "course id: " ?cid crlf)
    (retract ?c)
    (assert (search-tid ?tid ?cid FIN)))

(defrule remove-search-tid
    (declare (salience -1))
    (fix-tid ?tid)
    (hint-tid ?tid)
    (not (search-tid ?tid ?cid INIT))
    ?t <- (search-tid ?tid ?cid FIN)
=>
    (retract ?t))

(defrule remove-control
    (declare (salience -1))
    (not (search-tid ?tid ?cid FIN))
    (not (search-tid ?tid ?cid INIT))
    ?h <- (hint-tid ?tid)
    ?f <- (fix-tid ?tid)
    ?i <- (search-tid ?tid INIT)
=>
    (retract ?h)
    (retract ?f)
    (retract ?i))

;; 第二題：

(defrule expand-cids
    ?c <- (taughtby $?cids)
=>
    (progn$ (?cid $?cids)
        (assert (search-cid ?cid INIT)))
    (retract ?c))

(defrule fix-cid
    ?i <- (search-cid ?cid INIT)
    (not (search-cid ?cid NONE))
    (not (fix-cid $?))
=>
    (retract ?i)
    (assert (fix-cid ?cid))
    (assert (search-cid ?cid ?cid)))

(defrule search-course
    (fix-cid ?fid)
    ?c <- (search-cid ?fid ?cid)
    (course (course-id ?cid)
            (teacher-id $?tids)
            (pre-cond $?pre-cids))
=>
    (progn$ (?pre-cid $?pre-cids)
        (assert (search-cid ?fid ?pre-cid))))

(defrule display-cid-info
    (fix-cid ?fid)
    (not (hint ?fid))
    ?n <- (search-cid ?fid NONE)
=>
    (printout t "a student joined course " ?fid " has taught by:" crlf)
    (assert (hint ?fid)))

(defrule convert-tid
    (fix-cid ?fid)
    ?h <- (hint ?fid)
    ?s <- (search-cid ?fid ?cid)
    (course (course-id ?cid)
            (teacher-id $?tids))
=>
    (progn$ (?tid $?tids)
        (assert (taught-his ?fid ?tid)))
    (retract ?s))

(defrule display-tid-info
    (fix-cid ?fid)
    (hint ?fid)
    (search-cid ?fid NONE)
    (not (search-cid ?fid ?fid))
    ?h <- (taught-his ?fid ?tid)
=>
    (printout t "teacher id: " ?tid crlf)
    (retract ?h)
    (assert (taught-his ?fid ?tid DISP)))

(defrule hit-none
    ?f <- (fix-cid ?fid)
    (hint ?fid)
    (search-cid ?fid NONE)
=>
    (retract ?f))

(defrule remove-none
    (hint ?fid)
    (not (fix-cid ?fid))
    ?n <- (search-cid ?fid NONE)
=>
    (retract ?n))

(defrule remove-taught-his
    (hint ?fid)
    (not (fix-cid ?fid))
    (not (search-cid ?fid NONE))
    ?h <- (taught-his ?fid $? DISP)
=>
    (retract ?h))

(defrule remove-hint
    ?h <- (hint ?fid)
    (not (fix-cid ?fid))
    (not (search-cid ?fid NONE))
    (not (taught-his ?fid $? DISP))
=>
    (retract ?h))
