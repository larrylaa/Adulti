import {mkdir, writeFile} from "node:fs/promises";
import path from "node:path";

const API_KEY = process.env.ELEVENLABS_API_KEY;
const VOICE_ID = process.env.ELEVENLABS_VOICE_ID ?? "pNInz6obpgDQGcFmaJgB";
const MODEL_ID = process.env.ELEVENLABS_MODEL_ID ?? "eleven_multilingual_v2";
const PREFERRED_OUTPUT_FORMAT =
  process.env.ELEVENLABS_OUTPUT_FORMAT ?? "mp3_44100_128";
const OUTPUT_FORMAT_FALLBACKS = [PREFERRED_OUTPUT_FORMAT, "mp3_22050_32"];
const OUTPUT_DIR = path.resolve("public", "voiceover-cues");

if (!API_KEY) {
  console.error("Missing ELEVENLABS_API_KEY in environment.");
  process.exit(1);
}

const cues = [
  ["intro-01.mp3", "Adulting is hard."],
  ["intro-02.mp3", "Especially finances."],
  [
    "intro-03.mp3",
    "They did not teach us this in school, so no wonder it all sounds like gibberish.",
  ],
  ["reveal-01.mp3", "But there is a better way to navigate."],
  ["reveal-02.mp3", "Introducing Adulti."],
  ["onboarding-01.mp3", "Tell Adulti where you are right now."],
  [
    "onboarding-02.mp3",
    "Set checking, savings, emergency fund goals, debt, and retirement.",
  ],
  ["onboarding-03.mp3", "Now add income so your plan fits your real life."],
  ["onboarding-04.mp3", "Your dashboard adapts to your stage instantly."],
  ["onboarding-05.mp3", "Now you are ready for the next move."],
  ["roadmap-01.mp3", "Roadmap turns goals into clear next actions."],
  ["roadmap-02.mp3", "Each step explains what to do and why it matters."],
  ["roadmap-03.mp3", "Stay focused with one practical next move."],
  ["guide-01.mp3", "Guides break big money topics into simple steps."],
  ["guide-02.mp3", "Follow practical checklists you can use today."],
  ["guide-03.mp3", "Build confidence with repeatable playbooks."],
  ["feedback-01.mp3", "Here's what users are saying about Adulti."],
  [
    "outro-01.mp3",
    "Stop guessing. Start navigating. Get it on Google Play.",
  ],
];

const synthesizeCue = async (text) => {
  for (const outputFormat of OUTPUT_FORMAT_FALLBACKS) {
    const url = `https://api.elevenlabs.io/v1/text-to-speech/${VOICE_ID}/stream?output_format=${outputFormat}`;
    const response = await fetch(url, {
      method: "POST",
      headers: {
        "xi-api-key": API_KEY,
        "Content-Type": "application/json",
        Accept: "audio/mpeg",
      },
      body: JSON.stringify({
        text,
        model_id: MODEL_ID,
        voice_settings: {
          stability: 0.45,
          similarity_boost: 0.85,
          style: 0.15,
          use_speaker_boost: true,
        },
      }),
    });

    if (response.ok) {
      const audioArrayBuffer = await response.arrayBuffer();
      return {audio: Buffer.from(audioArrayBuffer), outputFormat};
    }

    const errorText = await response.text();
    const isFormatOrTierError =
      response.status === 403 &&
      (errorText.includes("output_format_not_allowed") ||
        errorText.includes("subscription_required"));
    if (!isFormatOrTierError || outputFormat === OUTPUT_FORMAT_FALLBACKS.at(-1)) {
      throw new Error(`ElevenLabs ${response.status}: ${errorText}`);
    }
  }

  throw new Error("ElevenLabs synthesis failed without a response.");
};

await mkdir(OUTPUT_DIR, {recursive: true});

for (const [filename, text] of cues) {
  process.stdout.write(`Generating ${filename}... `);
  const {audio, outputFormat} = await synthesizeCue(text);
  const filePath = path.join(OUTPUT_DIR, filename);
  await writeFile(filePath, audio);
  process.stdout.write(`done (${outputFormat})\n`);
}

console.log(
  `Complete. Generated ${cues.length} cue files using voice ${VOICE_ID} and model ${MODEL_ID}.`,
);
