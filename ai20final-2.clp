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
