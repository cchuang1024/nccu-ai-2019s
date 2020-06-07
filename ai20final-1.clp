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
    (printout t "tid: " ?tid " cid: " ?cid crlf)
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
