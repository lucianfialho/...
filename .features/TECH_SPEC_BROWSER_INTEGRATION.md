# Tech Spec: Browser Integration & Multi-Platform Support 🌐🔗

## 📋 **Visão Geral**

Expandir o AutoSkipp para além do CLI, criando integração profunda com browsers, extensões web, e sincronização cross-platform para uma experiência unificada de automação Claude Code.

## 🎯 **Objetivos**

- **Browser Extension**: AutoSkipp nativo no browser
- **Cross-platform sync**: Configurações sincronizadas entre devices
- **Real-time communication**: CLI ↔ Browser ↔ Cloud
- **Universal automation**: Funciona independente do ambiente Claude Code
- **Enhanced detection**: Melhor detecção via DOM/JavaScript

## 🏗️ **Arquitetura Distribuída**

### **Core Ecosystem**
```typescript
interface AutoSkippEcosystem {
  // Componentes principais
  cli_agent: AutoSkippCLI;           // Agente local CLI
  browser_extension: BrowserExtension; // Extensão web
  cloud_sync: CloudSyncService;      // Sincronização
  mobile_companion: MobileApp;       // App mobile (futuro)
  
  // Comunicação
  messaging: UniversalMessaging;     // Protocolo de comunicação
  state_sync: StateManager;         // Estado distribuído
  
  // Dados compartilhados
  user_preferences: SyncedPreferences;
  behavior_patterns: BehaviorSync;
  automation_rules: RuleEngine;
}
```

## 🌐 **Browser Extension**

### **1. Manifest & Architecture**
```json
// manifest.json (Manifest V3)
{
  "manifest_version": 3,
  "name": "AutoSkipp - Claude Code Automation",
  "version": "1.0.0",
  "description": "🤖⏰ Automação inteligente para Claude Code no browser",
  
  "permissions": [
    "activeTab",
    "storage", 
    "scripting",
    "background",
    "notifications",
    "webNavigation"
  ],
  
  "host_permissions": [
    "https://claude.ai/*",
    "https://*.anthropic.com/*"
  ],
  
  "background": {
    "service_worker": "background.js"
  },
  
  "content_scripts": [{
    "matches": ["https://claude.ai/*"],
    "js": ["content-script.js"],
    "css": ["autoskipp-ui.css"]
  }],
  
  "action": {
    "default_popup": "popup.html",
    "default_title": "AutoSkipp"
  },
  
  "web_accessible_resources": [{
    "resources": ["injected-script.js"],
    "matches": ["https://claude.ai/*"]
  }]
}
```

### **2. Content Script Integration**
```typescript
class ClaudeBrowserIntegration {
  private domObserver: MutationObserver;
  private stateDetector: BrowserStateDetector;
  private automationEngine: BrowserAutomationEngine;
  
  constructor() {
    this.initializeDetection();
    this.setupAutomation();
    this.connectToCLI();
  }
  
  initializeDetection() {
    this.stateDetector = new BrowserStateDetector({
      selectors: {
        input_field: 'textarea[placeholder*="Message"], div[contenteditable="true"]',
        submit_button: 'button[type="submit"], button[aria-label*="Send"]',
        loading_indicator: '.loading, .spinner, [data-testid="loading"]',
        error_message: '.error, .alert, [role="alert"]',
        permission_dialog: '[role="dialog"], .modal, .permission-request'
      },
      
      states: {
        waiting_for_input: () => this.detectWaitingState(),
        processing: () => this.detectProcessingState(),
        error: () => this.detectErrorState(),
        permission_needed: () => this.detectPermissionDialog()
      }
    });
  }
  
  detectWaitingState(): DetectionResult {
    const input = document.querySelector(this.stateDetector.selectors.input_field);
    const submit = document.querySelector(this.stateDetector.selectors.submit_button);
    const loading = document.querySelector(this.stateDetector.selectors.loading_indicator);
    
    return {
      detected: !!(input && submit && !loading && !submit.disabled),
      confidence: this.calculateConfidence([
        input?.matches(':focus') ? 0.3 : 0,
        submit?.disabled === false ? 0.2 : 0,
        !loading ? 0.2 : 0,
        input?.value?.length === 0 ? 0.3 : 0
      ]),
      context: {
        input_focused: input?.matches(':focus'),
        submit_enabled: !submit?.disabled,
        input_empty: input?.value?.length === 0
      }
    };
  }
  
  async startAutomation(config: AutomationConfig): Promise<AutomationResult> {
    const ui = this.createCountdownUI(config);
    document.body.appendChild(ui.element);
    
    return new Promise((resolve) => {
      const countdown = new CountdownTimer(config.timeout, {
        onTick: (remaining) => ui.updateProgress(remaining, config.timeout),
        onComplete: async () => {
          await this.executeAutomation(config);
          ui.remove();
          resolve({ success: true, method: 'automated' });
        },
        onCancel: () => {
          ui.remove();
          resolve({ success: false, method: 'cancelled' });
        }
      });
      
      // Cancela se usuário começar a digitar
      this.setupInterruptionDetection(countdown);
      countdown.start();
    });
  }
  
  createCountdownUI(config: AutomationConfig): CountdownUI {
    return new CountdownUI({
      position: config.ui_position || 'bottom-right',
      theme: config.theme || 'claude-native',
      template: `
        <div class="autoskipp-countdown">
          <div class="countdown-header">
            🤖 AutoSkipp ${config.context || 'ativo'}
          </div>
          <div class="progress-bar">
            <div class="progress-fill"></div>
          </div>
          <div class="countdown-info">
            <span class="time-remaining">${config.timeout}s</span>
            <span class="action-hint">Pressione ESC para cancelar</span>
          </div>
        </div>
      `
    });
  }
}
```

### **3. Advanced DOM Interaction**
```typescript
class BrowserAutomationEngine {
  async executeAutomation(action: AutomationAction): Promise<void> {
    switch (action.type) {
      case 'click_submit':
        await this.clickSubmitButton();
        break;
        
      case 'accept_permission':
        await this.acceptPermissionDialog();
        break;
        
      case 'retry_request':
        await this.retryLastAction();
        break;
        
      case 'clear_and_retry':
        await this.clearInputAndRetry();
        break;
    }
  }
  
  async clickSubmitButton(): Promise<void> {
    const submitBtn = this.findSubmitButton();
    if (!submitBtn) throw new Error('Submit button not found');
    
    // Simula interação humana
    await this.humanLikeClick(submitBtn);
    
    // Verifica se ação foi bem-sucedida
    await this.waitForResponse();
  }
  
  async humanLikeClick(element: HTMLElement): Promise<void> {
    // Simula movimento de mouse e timing humano
    const rect = element.getBoundingClientRect();
    const x = rect.left + rect.width / 2;
    const y = rect.top + rect.height / 2;
    
    // Dispara eventos em sequência realística
    element.dispatchEvent(new MouseEvent('mouseenter'));
    await this.delay(50 + Math.random() * 100);
    
    element.dispatchEvent(new MouseEvent('mousedown', { clientX: x, clientY: y }));
    await this.delay(80 + Math.random() * 120);
    
    element.dispatchEvent(new MouseEvent('mouseup', { clientX: x, clientY: y }));
    element.dispatchEvent(new MouseEvent('click', { clientX: x, clientY: y }));
  }
  
  async detectResponseReceived(): Promise<boolean> {
    return new Promise((resolve) => {
      const observer = new MutationObserver((mutations) => {
        for (const mutation of mutations) {
          // Detecta nova mensagem de Claude aparecendo
          if (mutation.type === 'childList') {
            const addedNodes = Array.from(mutation.addedNodes);
            const hasNewMessage = addedNodes.some(node => 
              node instanceof Element && 
              node.matches('.message, .response, .claude-response')
            );
            
            if (hasNewMessage) {
              observer.disconnect();
              resolve(true);
            }
          }
        }
      });
      
      observer.observe(document.body, {
        childList: true,
        subtree: true
      });
      
      // Timeout after 30 seconds
      setTimeout(() => {
        observer.disconnect();
        resolve(false);
      }, 30000);
    });
  }
}
```

## 🔄 **CLI ↔ Browser Communication**

### **1. Native Messaging Protocol**
```typescript
// Browser Extension ↔ CLI Native Messaging
class NativeMessagingBridge {
  private port: chrome.runtime.Port;
  
  constructor() {
    this.setupNativeMessaging();
  }
  
  setupNativeMessaging() {
    // Conecta com aplicativo nativo (CLI)
    this.port = chrome.runtime.connectNative('com.autoskipp.cli');
    
    this.port.onMessage.addListener((message: NativeMessage) => {
      this.handleCLIMessage(message);
    });
    
    this.port.onDisconnect.addListener(() => {
      console.log('CLI connection lost');
      this.attemptReconnection();
    });
  }
  
  async sendToCLI(command: CLICommand): Promise<CLIResponse> {
    return new Promise((resolve, reject) => {
      const messageId = this.generateMessageId();
      
      this.port.postMessage({
        id: messageId,
        command: command.type,
        data: command.payload
      });
      
      const listener = (response: NativeMessage) => {
        if (response.id === messageId) {
          this.port.onMessage.removeListener(listener);
          resolve(response.data);
        }
      };
      
      this.port.onMessage.addListener(listener);
      
      // Timeout
      setTimeout(() => {
        reject(new Error('CLI communication timeout'));
      }, 5000);
    });
  }
}

// CLI side - Native messaging host
class NativeMessagingHost {
  constructor() {
    this.setupMessageHandling();
  }
  
  setupMessageHandling() {
    process.stdin.on('readable', () => {
      const input = process.stdin.read();
      if (input) {
        const message = this.parseMessage(input);
        this.handleBrowserMessage(message);
      }
    });
  }
  
  async handleBrowserMessage(message: BrowserMessage) {
    const response = await this.processCommand(message.command, message.data);
    this.sendToBrowser({
      id: message.id,
      success: true,
      data: response
    });
  }
  
  sendToBrowser(response: CLIResponse) {
    const message = JSON.stringify(response);
    const length = Buffer.byteLength(message);
    
    process.stdout.write(Buffer.from([length & 0xff, (length >> 8) & 0xff, 
                                     (length >> 16) & 0xff, (length >> 24) & 0xff]));
    process.stdout.write(message);
  }
}
```

### **2. WebSocket Real-time Sync**
```typescript
class RealTimeSync {
  private ws: WebSocket;
  private syncQueue: SyncOperation[] = [];
  
  constructor(private userId: string) {
    this.connectToSyncServer();
  }
  
  connectToSyncServer() {
    this.ws = new WebSocket(`wss://sync.autoskipp.dev/${this.userId}`);
    
    this.ws.onopen = () => {
      console.log('Sync server connected');
      this.processPendingOperations();
    };
    
    this.ws.onmessage = (event) => {
      const syncOp = JSON.parse(event.data) as SyncOperation;
      this.applySyncOperation(syncOp);
    };
  }
  
  async syncSettings(settings: AutoSkippSettings): Promise<void> {
    const operation: SyncOperation = {
      type: 'settings_update',
      timestamp: Date.now(),
      device_id: await this.getDeviceId(),
      data: settings
    };
    
    if (this.ws.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(operation));
    } else {
      this.syncQueue.push(operation);
    }
  }
  
  async syncBehaviorPatterns(patterns: BehaviorPattern[]): Promise<void> {
    const operation: SyncOperation = {
      type: 'behavior_sync',
      timestamp: Date.now(),
      device_id: await this.getDeviceId(),
      data: { patterns }
    };
    
    this.queueSyncOperation(operation);
  }
}
```

## 📱 **Cross-Platform State Management**

### **1. Universal Settings Store**
```typescript
interface UniversalSettings {
  // Core automation settings
  automation: {
    default_timeout: number;
    smart_detection: boolean;
    context_awareness: boolean;
    interruption_sensitivity: number;
  };
  
  // UI preferences  
  ui: {
    theme: 'light' | 'dark' | 'claude-native';
    position: 'top-left' | 'top-right' | 'bottom-left' | 'bottom-right';
    animations: boolean;
    sound_enabled: boolean;
  };
  
  // Behavior patterns (learned)
  patterns: {
    typical_timeouts: { [context: string]: number };
    interruption_patterns: InterruptionPattern[];
    workflow_preferences: WorkflowPreference[];
  };
  
  // Privacy & data
  privacy: {
    telemetry_enabled: boolean;
    error_reporting: boolean;
    behavior_learning: boolean;
    cross_device_sync: boolean;
  };
}

class SettingsManager {
  private stores: SettingsStore[] = [];
  
  constructor() {
    // Registra diferentes stores baseado na plataforma
    if (typeof chrome !== 'undefined') {
      this.stores.push(new ChromeExtensionStore());
    }
    
    if (typeof process !== 'undefined') {
      this.stores.push(new CLIFileStore());
    }
    
    this.stores.push(new CloudSyncStore());
  }
  
  async getSettings(): Promise<UniversalSettings> {
    // Merge settings from all stores with priority
    const settingsList = await Promise.all(
      this.stores.map(store => store.load())
    );
    
    return this.mergeSettings(settingsList);
  }
  
  async updateSettings(partial: Partial<UniversalSettings>): Promise<void> {
    const current = await this.getSettings();
    const updated = { ...current, ...partial };
    
    // Update all stores
    await Promise.all(
      this.stores.map(store => store.save(updated))
    );
    
    // Broadcast changes
    this.broadcastSettingsChange(updated);
  }
}
```

### **2. Behavior Pattern Sync**
```typescript
class BehaviorPatternManager {
  async syncPatternAcrossDevices(pattern: BehaviorPattern): Promise<void> {
    const devices = await this.getConnectedDevices();
    
    await Promise.all(devices.map(device => 
      this.sendPatternUpdate(device, pattern)
    ));
  }
  
  async learnFromCrossDeviceData(): Promise<void> {
    const allPatterns = await this.collectPatternsFromAllDevices();
    const consolidatedLearning = this.consolidatePatterns(allPatterns);
    
    // Update ML models with cross-device data
    await this.updateBehaviorModels(consolidatedLearning);
  }
  
  consolidatePatterns(patterns: BehaviorPattern[][]): ConsolidatedPattern {
    return {
      timeout_preferences: this.consolidateTimeouts(patterns),
      workflow_patterns: this.consolidateWorkflows(patterns),
      context_preferences: this.consolidateContexts(patterns),
      reliability_score: this.calculateReliability(patterns)
    };
  }
}
```

## 🎮 **Enhanced User Experience**

### **1. Browser UI Components**
```typescript
class AutoSkippBrowserUI {
  createFloatingCountdown(config: CountdownConfig): FloatingUI {
    const ui = document.createElement('div');
    ui.className = 'autoskipp-floating-countdown';
    ui.innerHTML = `
      <div class="countdown-container">
        <div class="countdown-header">
          <span class="icon">🤖</span>
          <span class="title">AutoSkipp</span>
          <button class="close-btn">×</button>
        </div>
        
        <div class="countdown-body">
          <div class="context-info">${config.context}</div>
          <div class="circular-progress">
            <svg viewBox="0 0 100 100">
              <circle class="progress-bg" cx="50" cy="50" r="45"/>
              <circle class="progress-fill" cx="50" cy="50" r="45"/>
            </svg>
            <div class="time-display">${config.timeout}s</div>
          </div>
        </div>
        
        <div class="countdown-footer">
          <div class="action-hint">Pressione ESC para cancelar</div>
          <div class="confidence">Confiança: ${config.confidence}%</div>
        </div>
      </div>
    `;
    
    this.setupUIInteractions(ui);
    return new FloatingUI(ui);
  }
  
  createSettingsPanel(): SettingsPanel {
    return new SettingsPanel({
      sections: [
        {
          title: 'Automação',
          settings: [
            { key: 'default_timeout', type: 'slider', min: 1, max: 30 },
            { key: 'smart_detection', type: 'toggle' },
            { key: 'context_awareness', type: 'toggle' }
          ]
        },
        {
          title: 'Interface',
          settings: [
            { key: 'theme', type: 'select', options: ['light', 'dark', 'claude-native'] },
            { key: 'position', type: 'select', options: ['top-left', 'bottom-right'] }
          ]
        }
      ]
    });
  }
}
```

### **2. Smart Notifications**
```typescript
class SmartNotificationManager {
  async showContextualNotification(context: AutomationContext): Promise<void> {
    const notification = await this.createNotification({
      title: this.getContextualTitle(context),
      message: this.getContextualMessage(context),
      icon: '/icons/autoskipp-128.png',
      requireInteraction: context.severity === 'high',
      actions: this.getContextualActions(context)
    });
    
    notification.onclick = () => this.handleNotificationClick(context);
  }
  
  getContextualTitle(context: AutomationContext): string {
    const titles = {
      'waiting_for_input': '🤖 AutoSkipp Ready',
      'permission_needed': '🔓 Permission Required',
      'error_detected': '⚠️ Issue Detected',
      'workflow_completed': '✅ Workflow Complete'
    };
    
    return titles[context.type] || 'AutoSkipp';
  }
  
  getContextualActions(context: AutomationContext): NotificationAction[] {
    const baseActions = [
      { action: 'activate', title: 'Activate Now' },
      { action: 'dismiss', title: 'Dismiss' }
    ];
    
    if (context.confidence < 0.7) {
      baseActions.push({ action: 'adjust', title: 'Adjust Settings' });
    }
    
    return baseActions;
  }
}
```

## 🔧 **CLI Integration Commands**

### **Enhanced CLI with Browser Support**
```bash
# Browser extension management
$ autoskipp browser install
🌐 Installing browser extension...
✅ Chrome extension installed
💡 Restart browser to activate

$ autoskipp browser status  
🌐 Browser Integration Status
✅ Chrome extension: Active (v1.0.0)
✅ Native messaging: Connected
✅ Sync service: Online
⚠️  Firefox extension: Not installed

# Cross-device sync
$ autoskipp sync enable
🔄 Enabling cross-device synchronization...
🔑 Authentication required
📱 Scan QR code with mobile app or visit: https://sync.autoskipp.dev/auth

$ autoskipp sync status
🔄 Sync Status
✅ Devices: 3 connected (Mac CLI, Chrome Extension, iOS App)
📊 Last sync: 2 minutes ago
🔄 Pending operations: 0

# Browser automation control
$ autoskipp browser detect
🌐 Browser Detection
✅ Chrome: 3 Claude Code tabs detected
   • Tab 1: https://claude.ai/chat/abc123 (Active)  
   • Tab 2: https://claude.ai/project/xyz789 (Background)
   • Tab 3: https://claude.ai/docs (Background)

$ autoskipp browser activate --tab 1
🎯 Activating AutoSkipp on Tab 1...
✅ Automation started (3s countdown)

# Analytics cross-platform
$ autoskipp analytics --cross-device
📊 Cross-Device Analytics (Last 7 days)

🖥️  Mac CLI: 127 automations (94% success)
🌐 Chrome: 89 automations (96% success)  
📱 iOS App: 23 automations (91% success)

🎯 Most effective contexts:
   • Code review: 97% success across all platforms
   • Bug reports: 92% success (CLI performs best)
   • Documentation: 95% success (Browser performs best)
```

---

**Resultado:** AutoSkipp se torna **ecossistema completo multi-platform** com browser extension nativa, sync em tempo real, e experiência unificada! 🌐🔗✨