export const ADULTI_VIDEO = {
  width: 1080,
  height: 1920,
  fps: 30,
  durationInFrames: 2202,
};

export const SCENE_CROSSFADE_FRAMES = 24;
export const ONBOARD_TO_ROADMAP_GAP_FRAMES = 28;
export const ROADMAP_TO_GUIDE_GAP_FRAMES = 8;

export const SCENE_DURATION = {
  scene1: 270,
  scene2: 210,
  scene3: 600,
  scene4: 300,
  scene5: 420,
  scene6: 300,
  scene7: 210,
};

export const SCENE_START = {
  scene1: 0,
  scene2: SCENE_DURATION.scene1 - SCENE_CROSSFADE_FRAMES,
  scene3:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 -
    SCENE_CROSSFADE_FRAMES * 2,
  scene4:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 -
    SCENE_CROSSFADE_FRAMES * 3 +
    ONBOARD_TO_ROADMAP_GAP_FRAMES,
  scene5:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4 -
    SCENE_CROSSFADE_FRAMES * 4 +
    ONBOARD_TO_ROADMAP_GAP_FRAMES +
    ROADMAP_TO_GUIDE_GAP_FRAMES,
  scene6:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4 +
    SCENE_DURATION.scene5 -
    SCENE_CROSSFADE_FRAMES * 5 +
    ONBOARD_TO_ROADMAP_GAP_FRAMES +
    ROADMAP_TO_GUIDE_GAP_FRAMES,
  scene7:
    SCENE_DURATION.scene1 +
    SCENE_DURATION.scene2 +
    SCENE_DURATION.scene3 +
    SCENE_DURATION.scene4 +
    SCENE_DURATION.scene5 +
    SCENE_DURATION.scene6 -
    SCENE_CROSSFADE_FRAMES * 6 +
    ONBOARD_TO_ROADMAP_GAP_FRAMES +
    ROADMAP_TO_GUIDE_GAP_FRAMES,
};

export const STAGGER_MS = 80;
export const CARD_SPRING = {
  mass: 0.5,
  damping: 10,
};
