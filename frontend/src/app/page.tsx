type HealthResponse = { status: string };

type Result =
  | { ok: true; data: HealthResponse }
  | { ok: false; message: string };

async function checkHealth(): Promise<Result> {
  const backendUrl = process.env.BACKEND_URL;

  if (!backendUrl) throw new Error("No such BACKEND_URL variable");

  try {
    const response = await fetch(`${backendUrl}/actuator/health`, {
      cache: "no-store",
    });

    if (!response.ok) {
      return { ok: false, message: `Backend returns ${response.status}` };
    }

    return { ok: true, data: (await response.json()) as HealthResponse };
  } catch (error) {
    const detail = error instanceof Error ? error.message : String(error);
    return { ok: false, message: `No such connection to backend: ${detail}` };
  }
}

export default async function Home() {
  const result = await checkHealth();

  return (
    <main style={{ padding: "2rem", fontFamily: "sans-serif" }}>
      <h1>MorningCoffee - kontrola połączenia</h1>
      <p>
        Backend:
        <strong style={{ color: result.ok ? "#137333" : "#c5221f" }}>
          {result.ok ? result.data.status : result.message}
        </strong>
      </p>
    </main>
  );
}
