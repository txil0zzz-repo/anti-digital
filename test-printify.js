import "dotenv/config";
import https from "node:https";

const TOKEN = process.env.PRINTIFY_API_TOKEN;

if (!TOKEN) {
  console.error("Erro: PRINTIFY_API_TOKEN não encontrado no .env");
  process.exit(1);
}

const options = {
  hostname: "api.printify.com",
  path: "/v1/shops.json",
  method: "GET",
  headers: {
    Authorization: `Bearer ${TOKEN}`,
    "Content-Type": "application/json",
    "User-Agent": "anti-TEZ/1.0",
  },
};

const req = https.request(options, (res) => {
  let body = "";

  res.on("data", (chunk) => (body += chunk));

  res.on("end", () => {
    if (res.statusCode < 200 || res.statusCode >= 300) {
      console.error(`Erro HTTP ${res.statusCode}: ${res.statusMessage}`);
      try {
        const err = JSON.parse(body);
        console.error("Detalhe:", JSON.stringify(err, null, 2));
      } catch {
        console.error("Corpo:", body);
      }
      process.exit(1);
    }

    let shops;
    try {
      shops = JSON.parse(body);
    } catch {
      console.error("Erro: resposta não é JSON válido.");
      console.error("Corpo recebido:", body);
      process.exit(1);
    }

    if (!Array.isArray(shops) || shops.length === 0) {
      console.log("Nenhuma shop encontrada.");
      return;
    }

    console.log(`\n${shops.length} shop(s) encontrada(s):\n`);
    for (const shop of shops) {
      console.log(`  ID          : ${shop.id}`);
      console.log(`  Título      : ${shop.title}`);
      console.log(`  Canal venda : ${shop.sales_channel}`);
      console.log("  ---");
    }
  });
});

req.on("error", (err) => {
  console.error("Erro de rede:", err.message);
  process.exit(1);
});

req.end();
