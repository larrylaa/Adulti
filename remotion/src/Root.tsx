import "./index.css";
import { Composition } from "remotion";
import { MyComposition, type MyCompositionProps } from "./Composition";
import { ADULTI_VIDEO } from "./adulti/timeline";

export const RemotionRoot: React.FC = () => {
  const defaultProps: MyCompositionProps = {
    musicSrc: "/music.mp3",
    voiceoverSrc: undefined,
    screenTextVoiceover: true,
    demoSlots: {
      onboardingDashboardSrc: "/Onboard.mp4",
      roadmapSrc: "/Roadmap.mp4",
      guideSrc: "/Guide.mp4",
    },
  };

  return (
    <>
      <Composition
        id="AdultiVerticalAd"
        component={MyComposition}
        durationInFrames={ADULTI_VIDEO.durationInFrames}
        fps={ADULTI_VIDEO.fps}
        width={ADULTI_VIDEO.width}
        height={ADULTI_VIDEO.height}
        defaultProps={defaultProps}
      />
    </>
  );
};
