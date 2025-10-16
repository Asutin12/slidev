/* eslint-disable no-console */

// Azure App Service 関連のサンプルコード

// #region azure-cli
// Azure CLI でのリソース作成コマンド例
export const azureCommands = {
  createResourceGroup: "az group create --name webapp-rg --location japaneast",
  createAppServicePlan:
    "az appservice plan create --name webapp-plan --resource-group webapp-rg --sku B1 --is-linux",
  createWebAppNodeJS:
    'az webapp create --name my-web-app --resource-group webapp-rg --plan webapp-plan --runtime "NODE:18-lts"',
  createWebAppPython:
    'az webapp create --name my-web-app --resource-group webapp-rg --plan webapp-plan --runtime "PYTHON:3.11"',
};
// #endregion azure-cli

// #region app-types
// App Service の種類
export const appServiceTypes = {
  webApps: {
    name: "Web Apps",
    description: "一般的な Web アプリケーションのホスティング",
    useCases: ["Web サイト", "Web アプリ", "SPA"],
  },
  apiApps: {
    name: "API Apps",
    description: "RESTful API のホスティングに特化",
    useCases: ["バックエンド API", "マイクロサービス"],
  },
  mobileApps: {
    name: "Mobile Apps",
    description: "モバイルアプリのバックエンド構築",
    useCases: ["iOS/Android アプリのバックエンド"],
  },
  functionApps: {
    name: "Function Apps",
    description: "サーバーレス関数の実行環境",
    useCases: ["定期実行タスク", "イベント処理", "軽量 API"],
  },
};
// #endregion app-types

// #region env-setup
// 環境変数の設定例
export const envConfig = {
  production: {
    API_URL: "https://your-app.azurewebsites.net/api",
    DATABASE_URL: "your_production_database_url",
    APPINSIGHTS_INSTRUMENTATIONKEY: "your_instrumentation_key",
  },
  development: {
    API_URL: "http://localhost:3000/api",
    DATABASE_URL: "your_local_database_url",
  },
};
// #endregion env-setup
