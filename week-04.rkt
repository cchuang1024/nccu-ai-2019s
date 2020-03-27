#lang racket

;;  假設從左上開始,點位為 (0 0),往右為第一位,右上為 (7 0),往下為第二位,左下為 (0 7),皇后的編號由左至右為 0 ~ 7

(require racket/function)

(define q0 (cons 0 4))
(define q1 (cons 1 5))
(define q2 (cons 2 6))
(define q3 (cons 3 3))
(define q4 (cons 4 4))
(define q5 (cons 5 5))
(define q6 (cons 6 6))
(define q7 (cons 7 5))

(define queens (list q0 q1 q2 q3 q4 q5 q6 q7))

(define get-column
  (lambda (queen)
    (car queen)))

(define get-row
  (lambda (queen)
    (cdr queen)))

(define h-func
  (lambda (queens queen)
    (let loop ([col (get-column queen)]
               [row (get-row queen)]
               [qs queens]
               [h 0])
      (if (null? qs)
          h
          (if (= col 0)
              (loop col row (rest qs) h)
              
              (let* ([current (first qs)]
                     [curr-col (get-column current)]
                     [curr-row (get-row current)])
                (if (= col curr-col)
                    h  ;; 只算對前面棋子的攻擊性,所以到自己就回傳
                    (if (or (= row curr-row)
                            (= (abs (- row curr-row))
                               (abs (- col curr-col))))
                        (loop col row (rest qs) (+ h 1))  ;; 有攻擊到前方棋子的情況
                        (loop col row (rest qs) h)  ;; 沒有攻擊到前方棋子的情況
                        ))))))))


(define h-sum (foldl + 0
                     (map (curry h-func queens)
                          queens)))

(displayln (string-append "此棋盤的 h 為"
                          (number->string h-sum)))