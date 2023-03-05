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
    (procedureType patient1 ablation)
    (= (reading heartRate) 80)
    (= (reading SpO2) 60)
    (= (reading respirationRate) 15)
    (= (reading bloopPressure1) 100)
    (= (reading bloopPressure1) 80)


    )
  (:goal (and (considerDischarge patient1)))
)
