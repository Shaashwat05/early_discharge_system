(define (problem soko-ichii-pallette)
  (:domain earlyDischarge)
  (:objects
    heartRate bloodPressure1 bloodPressure2 count SPO2 respirationRate - number
    patient1 - patient
    ablation CIED - procedure
    hear
    )
  (:init
    (= (reading count) 0)
    (operationPerformed patient1)
    ;;;;
    )
  (:goal (and (considerDischarge patient1)))
)
