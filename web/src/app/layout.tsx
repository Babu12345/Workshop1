import type { Metadata } from "next";
import "./globals.css";
import { Providers } from "./providers";

export const metadata: Metadata = {
  title: {
    default: "NYC Restaurant Compass",
    template: "%s · NYC Restaurant Compass",
  },
  description:
    "Pick a NYC restaurant and let your phone point the way. A build-a-website workshop demo.",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body>
        <Providers>{children}</Providers>
      </body>
    </html>
  );
}
