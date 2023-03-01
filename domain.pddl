(define (domain sokorobotto)
  (:requirements :typing)
  (:types
   pallette robot  - object
   location saleitem order shipment
  )
  (:predicates  
  (ships ?s - shipment ?or - order)
  (orders ?or - order ?i - saleitem)
  (unstarted ?s - shipment)
  (contains ?p - pallette ?i - saleitem)
  (connected ?loc - location ?loc - location)
  (at ?o - object ?loc - location)
  (free ?r - robot)
  (no-robot ?loc - location)
  (no-pallette ?loc - location)
  (packing-location ?loc - location)
  (available ?loc - location)
  (includes ?s - shipment ?i - saleitem)
  )
  (:action Pick     ; Robot Picking up pallette
  :parameters (?r - robot ?loc - location ?p - pallette)
  :precondition (and (free ?r) (at ?r ?loc) (at ?p ?loc))
  :effect (and (not(free ?r))) 
  )
  (:action Drop     ; Robot dropping the pallette
  :parameters (?r - robot ?loc - location ?p - pallette)
  :precondition (and (not(free ?r)) (at ?r ?loc) (at ?p ?loc))  
  :effect (and (free ?r))
  )
  (:action AddShipment      ; Adding items to the shipment from the pallette
  :parameters (?s - shipment ?loc - location ?p - pallette ?i - saleitem ?or - order)
  :precondition (and (packing-location ?loc) (available ?loc) (at ?p ?loc) (contains ?p ?i) (orders ?or ?i) (ships ?s ?or))
  :effect (and (includes ?s ?i)(not(contains ?p ?i))) 
  )
  (:action Move     ; Moving only the robot
  :parameters (?r - robot ?loc1 - location ?loc2 - location)
  :precondition (and (free ?r) (connected ?loc1 ?loc2) (no-robot ?loc2) (at ?r ?loc1))
  :effect (and (at ?r ?loc2) (no-robot ?loc1) (not(no-robot ?loc2)) ) 
  )
  (:action MovewithPallette     ; Moving the robot with the pallette
  :parameters (?r - robot ?loc1 - location ?loc2 - location ?p - pallette)
  :precondition (and (not(free ?r)) (connected ?loc1 ?loc2) (no-robot ?loc2) (no-pallette ?loc2) (at ?p ?loc1) (at ?r ?loc1))
  :effect (and (at ?r ?loc2) (no-robot ?loc1) (not(no-robot ?loc2))  
  (at ?p ?loc2) (no-pallette ?loc1) (not(no-pallette ?loc2)))
  )
  
)

