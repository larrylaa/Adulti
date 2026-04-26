export const ADULTI_COLORS = {
  background: "#F8FAFC",
  surface: "#FFFFFF",
  navy: "#1E3A5F",
  success: "#22C55E",
  warning: "#F59E0B",
  textPrimary: "#0F172A",
  textSecondary: "#64748B",
  borderNavySoft: "rgba(30, 58, 95, 0.10)",
  sageWash: "#E8F5E9",
};

export const ADULTI_RADII = {
  card: 16,
  button: 14,
  icon: 12,
};

export const ADULTI_FONTS = {
  heading: "'Space Grotesk', 'Inter', sans-serif",
  body: "'Inter', 'Arial', sans-serif",
};

export const SHARED_STYLES = {
  card: {
    borderRadius: ADULTI_RADII.card,
    border: `1.5px solid ${ADULTI_COLORS.borderNavySoft}`,
    backgroundColor: ADULTI_COLORS.surface,
    boxSizing: "border-box" as const,
  },
  button: {
    borderRadius: ADULTI_RADII.button,
    backgroundColor: ADULTI_COLORS.navy,
    color: ADULTI_COLORS.surface,
    border: "none",
  },
  iconTile: {
    borderRadius: ADULTI_RADII.icon,
    border: `1.5px solid ${ADULTI_COLORS.borderNavySoft}`,
    backgroundColor: ADULTI_COLORS.surface,
  },
};
