import {
  AbsoluteFill,
  Audio,
  Easing,
  Sequence,
  interpolate,
  staticFile,
  spring,
  useCurrentFrame,
  useVideoConfig,
} from "remotion";
import {
  ADULTI_COLORS,
  ADULTI_FONTS,
  ADULTI_RADII,
  SHARED_STYLES,
} from "./adulti/theme";
import {
  ADULTI_VIDEO,
  CARD_SPRING,
  SCENE_DURATION,
  SCENE_START,
} from "./adulti/timeline";

type DemoSlots = {
  onboardingLabel?: string;
  dashboardLabel?: string;
  roadmapLabel?: string;
  guideLabel?: string;
};

const ROADMAP_ITEM_INDEXES = [0, 1, 2, 3, 4, 5, 6];

export type MyCompositionProps = {
  musicSrc?: string;
  voiceoverSrc?: string;
  demoSlots?: DemoSlots;
};

const cardEntrance = (frame: number, fps: number, delayFrames: number) => {
  return spring({
    fps,
    frame: Math.max(0, frame - delayFrames),
    config: {
      mass: CARD_SPRING.mass,
      damping: CARD_SPRING.damping,
    },
  });
};

const resolveAudioSrc = (src: string) => {
  if (/^https?:\/\//.test(src)) {
    return src;
  }
  return staticFile(src);
};

const CompassLogo: React.FC<{ size?: number }> = ({ size = 170 }) => {
  return (
    <div
      style={{
        width: size,
        height: size,
        borderRadius: size / 2,
        background: ADULTI_COLORS.surface,
        border: `8px solid ${ADULTI_COLORS.navy}`,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        position: "relative",
        boxShadow: "0 10px 28px rgba(30, 58, 95, 0.20)",
      }}
    >
      <div
        style={{
          width: size * 0.33,
          height: size * 0.33,
          transform: "rotate(45deg)",
          background: ADULTI_COLORS.success,
          borderRadius: 8,
        }}
      />
      <div
        style={{
          position: "absolute",
          width: size * 0.12,
          height: size * 0.12,
          borderRadius: 999,
          background: ADULTI_COLORS.navy,
        }}
      />
    </div>
  );
};

const Scene1KineticHook: React.FC = () => {
  const frame = useCurrentFrame();
  const slotX = [180, 540, 900];
  const slotY = [220, 560, 900, 1240, 1580];
  const slotAngles = [-6, 5, -4, 6, -3, 4, -5, 3, -4, 5, -3, 4, -5, 3, -4];
  const words = [
    "TAXES",
    "DEBT",
    "SAVINGS",
    "401(k)",
    "STUDENT LOANS",
    "CREDIT SCORE",
    "APR",
    "INTEREST",
    "ROTH IRA",
    "CAREER ROI",
    "SALARY",
    "NET WORTH",
    "RENT",
    "EXPENSES",
    "EMERGENCY FUND",
  ];
  const chaosPhase = frame >= 120;

  return (
    <AbsoluteFill
      style={{
        backgroundColor:
          frame < 60 ? ADULTI_COLORS.navy : ADULTI_COLORS.background,
        display: "flex",
        alignItems: "center",
        justifyContent: "center",
        overflow: "hidden",
      }}
    >
      {frame < 120 ? (
        <div
          style={{
            fontFamily: ADULTI_FONTS.heading,
            color: frame < 60 ? ADULTI_COLORS.surface : ADULTI_COLORS.success,
            fontWeight: 800,
            fontSize: 110,
            textAlign: "center",
            letterSpacing: -1.5,
            transform: `scale(${interpolate(Math.sin(frame / 4), [-1, 1], [0.96, 1.05])})`,
          }}
        >
          {frame < 60 ? "ADULTING IS HARD." : "ESPECIALLY FINANCES."}
        </div>
      ) : null}
      {chaosPhase
        ? words.map((word, i) => {
            const enter = interpolate(
              frame,
              [120 + i * 2, 136 + i * 2],
              [0, 1],
              {
                extrapolateLeft: "clamp",
                extrapolateRight: "clamp",
              },
            );
            const col = i % 3;
            const row = Math.floor(i / 3);
            const x = slotX[col] + (((i * 23) % 13) - 6);
            const y = slotY[row] + (((i * 19) % 11) - 5);
            const angle = slotAngles[i];
            const adaptiveSize = Math.max(
              44,
              Math.min(78, 92 - word.length * 2.8),
            );
            const shakeX = Math.sin((frame + i * 17) * 0.9) * 4;
            const shakeY = Math.cos((frame + i * 13) * 1.1) * 3;
            return (
              <div
                key={word}
                style={{
                  position: "absolute",
                  left: x,
                  top: y,
                  width: 300,
                  fontFamily: ADULTI_FONTS.heading,
                  fontWeight: 700 + ((i % 2) as 0 | 1) * 100,
                  color:
                    i % 2 === 0
                      ? ADULTI_COLORS.navy
                      : ADULTI_COLORS.textPrimary,
                  fontSize: adaptiveSize,
                  textAlign: "center",
                  lineHeight: 0.95,
                  opacity: enter,
                  transform: `translate(${shakeX}px, ${shakeY}px) translate(-50%, -50%) rotate(${angle}deg) scale(${interpolate(enter, [0, 1], [0.65, 1])})`,
                }}
              >
                {word}
              </div>
            );
          })
        : null}
    </AbsoluteFill>
  );
};

const Scene2Reveal: React.FC = () => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const wipe = interpolate(frame, [0, 80], [0, 160], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
    easing: Easing.out(Easing.cubic),
  });
  const logoScale = spring({
    fps,
    frame: frame - 14,
    config: { mass: 0.5, damping: 10 },
  });
  const copyRise = spring({
    fps,
    frame: frame - 38,
    config: { mass: 0.5, damping: 10 },
  });

  return (
    <AbsoluteFill style={{ backgroundColor: ADULTI_COLORS.navy }}>
      <AbsoluteFill
        style={{
          backgroundColor: ADULTI_COLORS.background,
          clipPath: `circle(${wipe}% at 50% 50%)`,
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          gap: 34,
        }}
      >
        <div
          style={{
            transform: `scale(${interpolate(logoScale, [0, 1], [0.7, 1])})`,
          }}
        >
          <CompassLogo size={220} />
        </div>
        <div
          style={{
            opacity: copyRise,
            transform: `translateY(${interpolate(copyRise, [0, 1], [34, 0])}px)`,
            textAlign: "center",
            color: ADULTI_COLORS.textPrimary,
            fontFamily: ADULTI_FONTS.heading,
            fontWeight: 700,
            fontSize: 54,
            lineHeight: 1.12,
            maxWidth: 840,
            letterSpacing: -0.8,
          }}
        >
          There is a better way to navigate.
          <br />
          This is Adulti.
        </div>
      </AbsoluteFill>
    </AbsoluteFill>
  );
};

const Scene3OnboardingFlow: React.FC<{ label: string }> = ({ label }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const cardIn = cardEntrance(frame, fps, 0);
  const clickIn = cardEntrance(frame, fps, 70);
  const studentActive = frame > 110;

  return (
    <AbsoluteFill
      style={{
        backgroundColor: ADULTI_COLORS.background,
        justifyContent: "center",
        alignItems: "center",
      }}
    >
      <div
        style={{
          ...SHARED_STYLES.card,
          width: 870,
          padding: 42,
          transform: `translateY(${interpolate(cardIn, [0, 1], [60, 0])}px) scale(${interpolate(cardIn, [0, 1], [0.95, 1])})`,
          opacity: cardIn,
        }}
      >
        <div
          style={{
            fontFamily: ADULTI_FONTS.heading,
            color: ADULTI_COLORS.textPrimary,
            fontSize: 62,
            fontWeight: 800,
            letterSpacing: -1,
          }}
        >
          Path Selection
        </div>
        <div
          style={{
            marginTop: 10,
            fontFamily: ADULTI_FONTS.body,
            color: ADULTI_COLORS.textSecondary,
            fontSize: 32,
          }}
        >
          Adapts to your specific life stage.
        </div>
        <div style={{ marginTop: 34, display: "flex", gap: 16 }}>
          {["Student", "New Grad"].map((item) => {
            const selected =
              item === "Student" ? studentActive : !studentActive;
            return (
              <div
                key={item}
                style={{
                  flex: 1,
                  borderRadius: ADULTI_RADII.card,
                  border: `1.5px solid ${ADULTI_COLORS.borderNavySoft}`,
                  background: selected
                    ? "rgba(34, 197, 94, 0.16)"
                    : ADULTI_COLORS.surface,
                  padding: "28px 24px",
                  textAlign: "center",
                  fontFamily: ADULTI_FONTS.body,
                  fontSize: 34,
                  fontWeight: selected ? 700 : 500,
                  color: selected
                    ? ADULTI_COLORS.success
                    : ADULTI_COLORS.textPrimary,
                }}
              >
                {item}
              </div>
            );
          })}
        </div>
        <div
          style={{
            marginTop: 26,
            fontFamily: ADULTI_FONTS.body,
            fontSize: 24,
            color: ADULTI_COLORS.textSecondary,
          }}
        >
          Placeholder media: {label}
        </div>
      </div>
      <div
        style={{
          width: 92,
          height: 92,
          borderRadius: 999,
          border: `6px solid ${ADULTI_COLORS.success}`,
          position: "absolute",
          top: 975,
          left: 280,
          opacity: clickIn,
          transform: `scale(${interpolate(clickIn, [0, 1], [1.4, 1])})`,
        }}
      />
    </AbsoluteFill>
  );
};

const PhoneMockup: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  return (
    <div
      style={{
        width: 570,
        height: 1160,
        borderRadius: 72,
        border: "10px solid #0E1728",
        background: "#111827",
        boxShadow: "0 20px 80px rgba(15, 23, 42, 0.30)",
        transform: "perspective(1200px) rotateY(-8deg) rotateX(6deg)",
        position: "relative",
        overflow: "hidden",
      }}
    >
      <div
        style={{
          position: "absolute",
          top: 12,
          left: "50%",
          transform: "translateX(-50%)",
          width: 180,
          height: 24,
          borderRadius: 20,
          backgroundColor: "#0B1220",
          zIndex: 2,
        }}
      />
      <div
        style={{
          width: "100%",
          height: "100%",
          background: ADULTI_COLORS.background,
        }}
      >
        {children}
      </div>
    </div>
  );
};

const Scene4Roadmap: React.FC<{ label: string }> = ({ label }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const phoneIn = cardEntrance(frame, fps, 0);
  const scrollY = interpolate(frame, [0, 200], [0, -520], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
    easing: Easing.linear,
  });
  const zoom = spring({
    fps,
    frame: frame - 210,
    config: { mass: 0.5, damping: 10 },
  });
  const criticalPulse = interpolate(
    Math.sin(frame * 0.22),
    [-1, 1],
    [0.95, 1.04],
  );

  return (
    <AbsoluteFill
      style={{
        backgroundColor: ADULTI_COLORS.background,
        alignItems: "center",
        justifyContent: "center",
      }}
    >
      <div
        style={{
          transform: `translateY(${interpolate(phoneIn, [0, 1], [90, 0])}px) scale(${interpolate(zoom, [0, 1], [1, 1.2])})`,
        }}
      >
        <PhoneMockup>
          <div
            style={{
              padding: "66px 32px 24px",
              height: "100%",
              overflow: "hidden",
              position: "relative",
            }}
          >
            <div
              style={{
                fontFamily: ADULTI_FONTS.heading,
                fontSize: 46,
                fontWeight: 800,
                color: ADULTI_COLORS.textPrimary,
              }}
            >
              Roadmap
            </div>
            <div
              style={{
                fontFamily: ADULTI_FONTS.body,
                fontSize: 22,
                color: ADULTI_COLORS.textSecondary,
                marginTop: 6,
              }}
            >
              Placeholder media: {label}
            </div>
            <div
              style={{ marginTop: 26, transform: `translateY(${scrollY}px)` }}
            >
              {ROADMAP_ITEM_INDEXES.map((i) => {
                const amber = i === 3;
                return (
                  <div
                    key={i}
                    style={{
                      ...SHARED_STYLES.card,
                      marginBottom: 16,
                      minHeight: 124,
                      padding: 16,
                      position: "relative",
                      backgroundColor: amber
                        ? "rgba(245, 158, 11, 0.08)"
                        : ADULTI_COLORS.surface,
                    }}
                  >
                    {amber ? (
                      <div
                        style={{
                          position: "absolute",
                          left: 0,
                          top: 0,
                          bottom: 0,
                          width: 8,
                          borderTopLeftRadius: ADULTI_RADII.card,
                          borderBottomLeftRadius: ADULTI_RADII.card,
                          backgroundColor: ADULTI_COLORS.warning,
                        }}
                      />
                    ) : null}
                    <div
                      style={{
                        fontFamily: ADULTI_FONTS.heading,
                        fontSize: 26,
                        fontWeight: 700,
                        color: ADULTI_COLORS.textPrimary,
                        marginLeft: amber ? 16 : 0,
                      }}
                    >
                      {amber ? "Critical Next Step" : `Roadmap Step ${i + 1}`}
                    </div>
                    <div
                      style={{
                        fontFamily: ADULTI_FONTS.body,
                        fontSize: 18,
                        color: ADULTI_COLORS.textSecondary,
                        marginTop: 8,
                        marginLeft: amber ? 16 : 0,
                      }}
                    >
                      {amber
                        ? "No more analysis paralysis."
                        : "Actionable task with guided context."}
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </PhoneMockup>
      </div>
      {frame > 220 ? (
        <div
          style={{
            position: "absolute",
            top: 390,
            padding: "14px 24px",
            borderRadius: 999,
            backgroundColor: "rgba(245, 158, 11, 0.16)",
            color: ADULTI_COLORS.warning,
            fontFamily: ADULTI_FONTS.heading,
            fontSize: 34,
            fontWeight: 800,
            transform: `scale(${criticalPulse})`,
          }}
        >
          Critical Next Step
        </div>
      ) : null}
    </AbsoluteFill>
  );
};

const Scene5Guides: React.FC<{ label: string }> = ({ label }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();
  const tilesIn = cardEntrance(frame, fps, 0);
  const sheetIn = cardEntrance(frame, fps, 120);

  return (
    <AbsoluteFill
      style={{ backgroundColor: ADULTI_COLORS.background, padding: 80 }}
    >
      <div
        style={{
          fontFamily: ADULTI_FONTS.heading,
          fontSize: 72,
          fontWeight: 800,
          color: ADULTI_COLORS.textPrimary,
        }}
      >
        Tactical Guides
      </div>
      <div
        style={{
          fontFamily: ADULTI_FONTS.body,
          fontSize: 30,
          color: ADULTI_COLORS.textSecondary,
          marginTop: 10,
        }}
      >
        Placeholder media: {label}
      </div>

      <div
        style={{
          marginTop: 36,
          display: "grid",
          gridTemplateColumns: "repeat(2, 1fr)",
          gap: 18,
          opacity: tilesIn,
          transform: `translateY(${interpolate(tilesIn, [0, 1], [44, 0])}px)`,
        }}
      >
        {["Debt Strategy", "Career ROI", "Starter Buffer", "Credit Shield"].map(
          (item, i) => {
            const selected = i === 0;
            return (
              <div
                key={item}
                style={{
                  ...SHARED_STYLES.iconTile,
                  minHeight: 176,
                  padding: 22,
                  backgroundColor: selected
                    ? "rgba(34, 197, 94, 0.12)"
                    : ADULTI_COLORS.surface,
                  borderColor: selected
                    ? "rgba(34, 197, 94, 0.4)"
                    : ADULTI_COLORS.borderNavySoft,
                }}
              >
                <div
                  style={{
                    fontFamily: ADULTI_FONTS.heading,
                    fontSize: 38,
                    color: selected
                      ? ADULTI_COLORS.success
                      : ADULTI_COLORS.navy,
                  }}
                >
                  ▣
                </div>
                <div
                  style={{
                    fontFamily: ADULTI_FONTS.body,
                    fontSize: 30,
                    fontWeight: 600,
                    marginTop: 10,
                    color: ADULTI_COLORS.textPrimary,
                  }}
                >
                  {item}
                </div>
              </div>
            );
          },
        )}
      </div>

      <div
        style={{
          position: "absolute",
          left: 36,
          right: 36,
          bottom: 36,
          ...SHARED_STYLES.card,
          borderTopLeftRadius: 28,
          borderTopRightRadius: 28,
          borderBottomLeftRadius: ADULTI_RADII.card,
          borderBottomRightRadius: ADULTI_RADII.card,
          padding: 30,
          opacity: sheetIn,
          transform: `translateY(${interpolate(sheetIn, [0, 1], [180, 0])}px)`,
        }}
      >
        <div
          style={{
            fontFamily: ADULTI_FONTS.heading,
            fontSize: 44,
            fontWeight: 700,
            color: ADULTI_COLORS.textPrimary,
          }}
        >
          Debt Strategy
        </div>
        {[
          "List all balances with APR and minimum payment",
          "Prioritize highest APR debt first",
          "Automate payments and track monthly progress",
        ].map((line, i) => (
          <div
            key={line}
            style={{
              display: "flex",
              alignItems: "center",
              marginTop: 14 + i * 2,
              fontFamily: ADULTI_FONTS.body,
              fontSize: 25,
              color: ADULTI_COLORS.textSecondary,
            }}
          >
            <span style={{ color: ADULTI_COLORS.success, marginRight: 10 }}>
              ●
            </span>
            {line}
          </div>
        ))}
      </div>
    </AbsoluteFill>
  );
};

const Scene6SocialProof: React.FC = () => {
  const frame = useCurrentFrame();
  const comments = [
    "Finally a plan that makes sense.",
    "I actually know what to do this week.",
    "Debt payoff feels possible now.",
    "The checklist keeps me on track.",
    "I love seeing the next steps clearly.",
    "Way less overwhelmed about money.",
    "My APR strategy finally clicked.",
    "This made budgeting feel simple.",
    "I stopped missing important deadlines.",
    "The roadmap is super practical.",
    "Best guide for post-grad finances.",
    "I can explain my plan in 2 minutes.",
    "It turned confusion into action.",
    "My emergency fund is finally growing.",
    "Wish I had this in freshman year.",
    "I finally understand my credit score.",
    "This gave me a real salary game plan.",
    "Net worth tracking is way less scary now.",
  ];
  const slotX = [90, 420, 750];
  const slotY = [320, 570, 820, 1070, 1320, 1570];
  const bubbleAngles = [
    -2, 1, -1, 2, -2, 1, -1, 2, -2, 1, -1, 2, -2, 1, -1, 2, -2, 1,
  ];
  const fadeStagger = 7;
  const fadeDuration = 32;

  return (
    <AbsoluteFill
      style={{ backgroundColor: ADULTI_COLORS.background, overflow: "hidden" }}
    >
      <div
        style={{
          position: "absolute",
          left: 64,
          top: 74,
          zIndex: 2,
        }}
      >
        <div
          style={{
            fontFamily: ADULTI_FONTS.heading,
            fontSize: 74,
            fontWeight: 800,
            color: ADULTI_COLORS.textPrimary,
          }}
        >
          User Feedback
        </div>
        <div
          style={{
            fontFamily: ADULTI_FONTS.body,
            fontSize: 32,
            color: ADULTI_COLORS.textSecondary,
            marginTop: 16,
          }}
        >
          Tested by 50 students.
        </div>
      </div>

      {comments.map((comment, i) => {
        const col = i % 3;
        const row = Math.floor(i / 3);
        const enter = interpolate(
          frame,
          [22 + i * fadeStagger, 22 + i * fadeStagger + fadeDuration],
          [0, 1],
          {
            extrapolateLeft: "clamp",
            extrapolateRight: "clamp",
          },
        );
        const x = slotX[col] + (((i * 7) % 9) - 4);
        const y = slotY[row] + (((i * 5) % 7) - 3);

        return (
          <div
            key={comment}
            style={{
              position: "absolute",
              left: x,
              top: y,
              width: 250,
              minHeight: 150,
              opacity: enter,
              transform: `translateY(${interpolate(enter, [0, 1], [32, 0])}px) rotate(${bubbleAngles[i]}deg)`,
            }}
          >
            <div
              style={{
                ...SHARED_STYLES.card,
                borderRadius: 28,
                padding: "20px 20px 18px 20px",
                position: "relative",
                height: "100%",
              }}
            >
              <div
                style={{
                  position: "absolute",
                  left: 24,
                  bottom: -14,
                  width: 24,
                  height: 24,
                  background: ADULTI_COLORS.surface,
                  borderLeft: `1.5px solid ${ADULTI_COLORS.borderNavySoft}`,
                  borderBottom: `1.5px solid ${ADULTI_COLORS.borderNavySoft}`,
                  transform: "rotate(-45deg)",
                }}
              />
              <div
                style={{
                  fontFamily: ADULTI_FONTS.body,
                  fontSize: 27,
                  fontWeight: 650,
                  color: ADULTI_COLORS.textPrimary,
                  lineHeight: 1.15,
                }}
              >
                {comment}
              </div>
              <div
                style={{
                  marginTop: 10,
                  fontFamily: ADULTI_FONTS.body,
                  fontSize: 20,
                  color: ADULTI_COLORS.textSecondary,
                }}
              >
                Beta Tester
              </div>
            </div>
          </div>
        );
      })}
    </AbsoluteFill>
  );
};

const Scene7Outro: React.FC = () => {
  const frame = useCurrentFrame();
  const pulse = interpolate(Math.sin(frame * 0.16), [-1, 1], [0.98, 1.04]);
  const outroFade = interpolate(frame, [0, 40], [0.25, 1], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });

  return (
    <AbsoluteFill
      style={{
        background: `linear-gradient(180deg, ${ADULTI_COLORS.background} 0%, ${ADULTI_COLORS.sageWash} 100%)`,
        alignItems: "center",
        justifyContent: "center",
        gap: 40,
        opacity: outroFade,
      }}
    >
      <CompassLogo size={300} />
      <div
        style={{
          fontFamily: ADULTI_FONTS.heading,
          fontSize: 84,
          fontWeight: 800,
          color: ADULTI_COLORS.textPrimary,
          textAlign: "center",
          letterSpacing: -1.5,
          lineHeight: 1.06,
        }}
      >
        Stop guessing.
        <br />
        Start navigating.
      </div>

      <div
        style={{
          ...SHARED_STYLES.button,
          padding: "28px 64px",
          borderRadius: ADULTI_RADII.button,
          fontFamily: ADULTI_FONTS.heading,
          fontSize: 44,
          fontWeight: 800,
          letterSpacing: 0.4,
          transform: `scale(${pulse})`,
        }}
      >
        DOWNLOAD ADULTI
      </div>
    </AbsoluteFill>
  );
};

const audioVolume = (
  frame: number,
  durationInFrames: number,
  maxVolume: number,
) => {
  const fadeIn = interpolate(frame, [0, ADULTI_VIDEO.fps], [0, maxVolume], {
    extrapolateLeft: "clamp",
    extrapolateRight: "clamp",
  });
  const fadeOut = interpolate(
    frame,
    [durationInFrames - ADULTI_VIDEO.fps, durationInFrames],
    [maxVolume, 0],
    {
      extrapolateLeft: "clamp",
      extrapolateRight: "clamp",
    },
  );
  return Math.min(fadeIn, fadeOut);
};

export const MyComposition: React.FC<MyCompositionProps> = ({
  musicSrc,
  voiceoverSrc,
  demoSlots,
}) => {
  const { durationInFrames } = useVideoConfig();

  return (
    <AbsoluteFill style={{ backgroundColor: ADULTI_COLORS.background }}>
      {musicSrc ? (
        <Audio
          src={resolveAudioSrc(musicSrc)}
          volume={(frame) =>
            audioVolume(frame, durationInFrames, voiceoverSrc ? 0.24 : 0.65)
          }
        />
      ) : null}
      {voiceoverSrc ? (
        <Audio
          src={resolveAudioSrc(voiceoverSrc)}
          volume={(frame) => audioVolume(frame, durationInFrames, 1)}
        />
      ) : null}

      <Sequence
        from={SCENE_START.scene1}
        durationInFrames={SCENE_DURATION.scene1}
      >
        <Scene1KineticHook />
      </Sequence>
      <Sequence
        from={SCENE_START.scene2}
        durationInFrames={SCENE_DURATION.scene2}
      >
        <Scene2Reveal />
      </Sequence>
      <Sequence
        from={SCENE_START.scene3}
        durationInFrames={SCENE_DURATION.scene3}
      >
        <Scene3OnboardingFlow
          label={demoSlots?.onboardingLabel ?? "Onboarding clip placeholder"}
        />
      </Sequence>
      <Sequence
        from={SCENE_START.scene4}
        durationInFrames={SCENE_DURATION.scene4}
      >
        <Scene4Roadmap
          label={
            demoSlots?.roadmapLabel ?? "Dashboard/Roadmap clip placeholder"
          }
        />
      </Sequence>
      <Sequence
        from={SCENE_START.scene5}
        durationInFrames={SCENE_DURATION.scene5}
      >
        <Scene5Guides
          label={demoSlots?.guideLabel ?? "Guide clip placeholder"}
        />
      </Sequence>
      <Sequence
        from={SCENE_START.scene6}
        durationInFrames={SCENE_DURATION.scene6}
      >
        <Scene6SocialProof />
      </Sequence>
      <Sequence
        from={SCENE_START.scene7}
        durationInFrames={SCENE_DURATION.scene7}
      >
        <Scene7Outro />
      </Sequence>
    </AbsoluteFill>
  );
};
