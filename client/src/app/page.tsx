"use client";

import Image from "next/image";
import { useEffect, useState } from "react";
import styles from "./page.module.css";

import { Connect } from "@stacks/connect-react";
import ConnectWallet, { userSession } from "../components/ConnectWallet";

export default function Home() {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) return null;

  return (
    <Connect
      authOptions={{
        appDetails: {
          name: "StableStacks",
          icon: window.location.origin + "/logo.png",
        },
        redirectTo: "/",
        onFinish: () => {
          window.location.reload();
        },
        userSession,
      }}
    >
      <header className={styles.header}>
        <h1 className={styles.title}>StableStacks</h1>
        <div className={styles.headerActions}>
          <button className={styles.launchButton}>Launch App</button>
          <ConnectWallet />
        </div>
      </header>
      <main className={styles.main}>
        <p className={styles.slogan}>The world's first decentralized stablecoin</p>
        <div className={styles.imageContainer}>
          <Image
            src="/stacks.gif" // Corrected the relative path
            alt="Decentralized Stablecoin"
            width={300}
            height={300}
            priority
          />
        </div>
        <div className={styles.grid}>
          {/* Grid items go here */}
        </div>
      </main>
    </Connect>
  );
}
