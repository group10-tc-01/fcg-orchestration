#!/bin/bash

echo "🔌 Conectando ao SQL Server..."
echo ""
echo "Use as seguintes credenciais no SQL Server Management Studio:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Server:   localhost,1433"
echo "  Login:    sa"
echo "  Password: YourPassword123**"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "Databases disponíveis:"
echo "  - fcg_users"
echo "  - fcg_payments"
echo "  - fcg_catalog"
echo ""
echo "⚠️  Pressione Ctrl+C para encerrar a conexão"
echo ""

kubectl port-forward -n fcg-system service/sqlserver-service 1433:1433
