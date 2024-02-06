class Bee {
    PVector position;
    PVector velocity;
    PVector acceleration;
    PVector pbest;
    Flower closestFlower; // class attribute
    //float flowerDistance; // a scalar


    // Constants for bee's behavior
    float maxForce = 0.5; // Maximum steering force
    float maxSpeed = 2;   // Maximum speed
    float sniffDistance = 300; // the distance at which the bee smells the flower
    float pollinateDistance = 5;
   
    Bee() {
        position = new PVector(random(width), random(height-50));
        velocity = PVector.random2D();
        acceleration = new PVector(0, 0);
        pbest = position.copy();
    }
    
    void explore() {
        // Add some randomness to the velocity for exploration
        velocity.add(PVector.random2D().mult(EXPLORE_EXPLOIT_RATIO));
        closestFlower = findClosestFlower(flowers);
        
        if (closestFlower != null){
          float distToFlower = PVector.dist(position, closestFlower.position);
          
          if (distToFlower < sniffDistance && !closestFlower.visited){ // within sniff Distance. then the bee steers towards it
              PVector desired = PVector.sub(closestFlower.position, position);
              desired.setMag(maxSpeed);
              PVector steer = PVector.sub(desired, velocity);
              steer.limit(maxForce); // Limit the magnitude of the steering force
              applyForce(steer);
            }
          
          
          if (distToFlower < pollinateDistance) {
            pollinate();
          }
          
        }
    }
    
    
    float distanceToFlower(PVector point, Flower flower){
      float d = PVector.dist(point, flower.position);
      return d; // a scalar
    }
    
    Flower findClosestFlower(Flower[] flowers){
      float recordDist = 2000; // very high value
      Flower closest = null;
      for (Flower flower : flowers){
        float d = PVector.dist(position, flower.position);
        if (d < recordDist && d <= sniffDistance && !flower.visited){
          recordDist = d;
          closest = flower;
        }
      }
      return closest;
    }
    
    void communicate() {
        // Update global best if this bee has found a better solution
        if (closestFlower != null && distanceToFlower(position, closestFlower) < distanceToFlower(gbest, closestFlower)) {
            gbest = position.copy();
        }
    }

    void applyForce(PVector force) {
        // This function could be more complex if you want to limit the force
        acceleration.add(force);
    }

    void pollinate() {
        // Find the closest flower and steer towards it
        if (closestFlower != null){
          closestFlower.visited = true;
        }
    }

    void update() {
        // Update velocity
        velocity.add(acceleration);
        // Limit speed
        velocity.limit(maxSpeed);
        position.add(velocity);
        // Reset acceleration to 0 each cycle
        acceleration.mult(0);
        if (position.x > width || position.x < 0){
          velocity.x *= -1;
        }
        
        if (position.y > (height-200) || position.y < 0){
          velocity.y *= -1;
        }
        
        
        // Implement bounds checking and wrap around if necessary
    }

    void display() {
        fill(255, 255, 0);
        ellipse(position.x, position.y, 5, 5); // Draw the bee
    }

    // Additional helper methods like distanceToFlower and findClosestFlower
}
