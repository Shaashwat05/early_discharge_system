(define (problem soko-ichii-pallette)
  (:domain earlyDischarge)
  (:objects
    patient1 - patient
    heartRate1 - heartRate
    bloodPressure1 bloodPressure2 - bloodPressure
    SPO21 - SpO2
    respirationRate1 - respirationRate
    CIED1 - CIED
    ablation1 - ablation
    rassScore1 - rassScore
    wlkDist1 - wlkDist
    Hardik - doctor
  )
  (:init
    (operationPerformed patient1)
    (procedureType patient1 CIED1)
    (= (reading heartRate1) 125)
    (= (reading SPO21) 20)
    (= (reading respirationRate1) 35)
    (= (reading bloodPressure1) 170)
    (= (reading bloodPressure2) 30)
    (= (reading rassScore1) 0)
    (= (reading wlkDist1) 450)
    (deviceCheckNormal patient1)
    )
  (:goal (and (callMD Hardik)))
)
