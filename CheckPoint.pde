/**
* this stores the ceckpoint info. populated when loading and at time of crossing
*
*/
class CheckPoint {
  PVector loc;
  float angle;
  int score;
  int musicLoc;

  /**
   * Creates a camera where 0,0 is at x,y
   * @param loc_ x location for center
   * @param angle_ y location for center
   */
  CheckPoint(PVector loc_,float angle_) {
  loc = loc_;
  angle = angle_;
  }

}
