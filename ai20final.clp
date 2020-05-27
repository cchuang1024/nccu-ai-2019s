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

(deftemplate course-map
        (slot cid)
        (slot tid))

(reset)

(defrule expand-tids
    ?g <- (givenby $?tids)
=>
    (progn$ (?tid $?tids)
        (assert (search-tid ?tid)))
    (retract ?g))

(defrule search-by-teachers
    (not (givenby))
    ?s <- (search-tid ?tid)
    (forall (course (course-id ?cid)
                    (teacher-id ?tid $?)))
=>
    (assert (course-map (tid ?tid)
                        (cid ?cid)))
    (retract ?s)))

(defrule print-course-map
    (not (search-tid))
    ?c <- (course-map (cid ?cid)
                      (tid ?tid))
=>
        (printout t "find course: " ?cid " taught by " ?tid crlf)
        (retract ?c))

(assert (givenby P004 P006))

(agenda)

(run)


(deftemplate teacher-owned
    (slot teacher-id)
    (multislot course-id))
