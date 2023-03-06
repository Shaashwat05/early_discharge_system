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
    ;;;;
    )
  (:goal (and (checkMeds patient1)))
)
