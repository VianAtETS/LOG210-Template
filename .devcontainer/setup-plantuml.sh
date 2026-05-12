#!/usr/bin/env bash
set -euo pipefail

PLANTUML_VERSION="1.2026.2"
PLANTUML_DIR="/opt/plantuml"
JAR_URL="https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar"

sudo apt-get update -y
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    default-jre-headless \
    graphviz \
    librsvg2-bin
sudo rm -rf /var/lib/apt/lists/*

sudo mkdir -p "$PLANTUML_DIR"
sudo curl -fsSL --proto '=https' --tlsv1.2 -o "$PLANTUML_DIR/plantuml.jar" "$JAR_URL"

sudo tee /usr/local/bin/plantuml >/dev/null <<'EOF'
#!/usr/bin/env bash
exec java -jar /opt/plantuml/plantuml.jar "$@"
EOF
sudo chmod +x /usr/local/bin/plantuml

plantuml -version
