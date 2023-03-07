(define (problem soko-ichii-pallette)
  (:domain earlyDischarge)
  (:objects
    patient1 - patient
    heartRate1 - heartRate
    bp1 - bloodPressure1
    bp2 - bloodPressure2
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
    ;;;;
    )
  (:goal (and (startO2 patient1)))
)