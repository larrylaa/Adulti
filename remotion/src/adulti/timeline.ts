export const ADULTI_VIDEO = {
  width: 1080,
  height: 1920,
  fps: 30,
  durationInFrames: 2040,
};

export const SCENE_DURATION = {
  scene1: 180,
  scene2: 120,
  scene3: 300,
  scene4: 450,
  scene5: 360,
  scene6: 300,
  scene7: 330,
};

export const SCENE_START = {
  scene1: 0,
  scene2: SCENE_DURATION.scene1,
  scene3: SCENE_DURATION.scene1 + SCENE_DURATION.scene2,
  scene4: SCENE_DURATION.scene1 + SCENE_DURATION.scene2 + SCENE_DURATION.scene3,
  scene5:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4,
  scene6:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4 +
    SCENE_DURATION.scene5,
  scene7:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4 +
    SCENE_DURATION.scene5 +
    SCENE_DURATION.scene6,
};

export const STAGGER_MS = 80;
export const CARD_SPRING = {
  mass: 0.5,
  damping: 10,
};
