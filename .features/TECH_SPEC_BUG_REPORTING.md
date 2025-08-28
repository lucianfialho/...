# Tech Spec: Bug Reporting & Log Collection 🐛📋

## 📋 **Visão Geral**

Transformar o AutoSkipp num sistema avançado de observabilidade que coleta logs, detecta bugs, captura contexto de erros e facilita debugging tanto para usuários quanto para desenvolvimento da ferramenta.

## 🎯 **Objetivos**

- **Bug detection automático**: Detectar erros antes do usuário reportar
- **Context capture**: Coletar informações relevantes automaticamente  
- **Smart reporting**: Relatórios inteligentes com análise automática
- **Debugging assistance**: Ferramentas para ajudar usuários e desenvolvedores
- **Ecosystem observability**: Monitoramento da saúde do Claude Code

## 🏗️ **Arquitetura**

### **Core Logging System**
```python
class IntelligentLogger:
    def __init__(self):
        self.collectors = [
            SystemStateCollector(),
            ClaudeCodeStateCollector(),
            BrowserStateCollector(),
            UserInteractionCollector(),
            PerformanceCollector(),
            ErrorDetector()
        ]
        
        self.analyzers = [
            LogPatternAnalyzer(),
            AnomalyDetector(),
            RootCauseAnalyzer(),
            ImpactAssessment()
        ]
        
        self.reporters = [
            SmartBugReporter(),
            TelemetryReporter(),
            UserFeedbackCollector()
        ]
    
    async def capture_context(self, event_type: str) -> BugContext:
        context = BugContext()
        
        for collector in self.collectors:
            data = await collector.collect()
            context.add_data(collector.name, data)
        
        return context
```

## 🔍 **Data Collectors**

### **1. System State Collector**
```python
class SystemStateCollector:
    """Coleta estado completo do sistema"""
    
    async def collect(self) -> SystemState:
        return {
            "os_info": {
                "platform": platform.system(),
                "version": platform.release(),
                "architecture": platform.machine(),
                "python_version": sys.version,
                "environment_vars": self.get_relevant_env_vars()
            },
            
            "process_info": {
                "autoskipp_pid": os.getpid(),
                "memory_usage": psutil.Process().memory_info(),
                "cpu_usage": psutil.Process().cpu_percent(),
                "open_files": len(psutil.Process().open_files()),
                "threads": psutil.Process().num_threads()
            },
            
            "system_resources": {
                "total_memory": psutil.virtual_memory().total,
                "available_memory": psutil.virtual_memory().available,
                "cpu_count": psutil.cpu_count(),
                "disk_usage": psutil.disk_usage('/').percent
            },
            
            "network_state": {
                "connections": len(psutil.net_connections()),
                "network_io": psutil.net_io_counters(),
                "dns_resolution_time": await self.test_dns_resolution()
            }
        }
    
    def get_relevant_env_vars(self):
        relevant = ['PATH', 'PYTHONPATH', 'CLAUDE_PROJECT_DIR', 'HOME', 'USER']
        return {k: os.environ.get(k) for k in relevant if k in os.environ}
```

### **2. Claude Code State Collector**
```python
class ClaudeCodeStateCollector:
    """Monitora estado específico do Claude Code"""
    
    async def collect(self) -> ClaudeState:
        return {
            "process_detection": {
                "claude_processes": self.find_claude_processes(),
                "process_health": await self.check_process_health(),
                "memory_usage": self.get_claude_memory_usage(),
                "cpu_usage": self.get_claude_cpu_usage()
            },
            
            "window_state": {
                "active_windows": self.get_claude_windows(),
                "window_positions": self.get_window_geometry(),
                "focus_state": self.check_window_focus(),
                "visibility": self.check_window_visibility()
            },
            
            "hook_state": {
                "installed_hooks": self.check_installed_hooks(),
                "hook_execution_history": self.get_hook_history(),
                "hook_errors": self.get_hook_errors(),
                "settings_integrity": self.verify_settings_file()
            },
            
            "interaction_state": {
                "last_interaction": self.get_last_interaction_time(),
                "input_field_state": self.detect_input_field_state(),
                "loading_indicators": self.detect_loading_state(),
                "error_dialogs": self.detect_error_dialogs()
            }
        }
    
    async def check_process_health(self):
        processes = self.find_claude_processes()
        health_checks = []
        
        for proc in processes:
            health = {
                "pid": proc.pid,
                "status": proc.status(),
                "responsive": await self.test_process_responsiveness(proc),
                "memory_leaks": self.detect_memory_leaks(proc),
                "zombie_state": proc.status() == psutil.STATUS_ZOMBIE
            }
            health_checks.append(health)
        
        return health_checks
```

### **3. Browser State Collector**
```python
class BrowserStateCollector:
    """Coleta estado do browser quando Claude Code roda nele"""
    
    async def collect(self) -> BrowserState:
        return {
            "browser_detection": {
                "running_browsers": self.detect_browsers(),
                "claude_tabs": await self.find_claude_tabs(),
                "browser_versions": self.get_browser_versions(),
                "extensions": self.get_relevant_extensions()
            },
            
            "performance_metrics": {
                "page_load_times": self.get_load_times(),
                "javascript_errors": self.get_js_errors(),
                "network_requests": self.get_network_activity(),
                "memory_usage": self.get_browser_memory()
            },
            
            "console_logs": {
                "errors": self.extract_console_errors(),
                "warnings": self.extract_console_warnings(),
                "network_failures": self.extract_network_errors(),
                "claude_specific_logs": self.filter_claude_logs()
            }
        }
    
    async def extract_console_errors(self):
        """Extrai erros do console do browser via debugging APIs"""
        if self.browser_debugging_available():
            return await self.get_console_logs(level='error')
        return []
```

### **4. User Interaction Collector**
```python
class UserInteractionCollector:
    """Coleta padrões de interação do usuário (com privacidade)"""
    
    async def collect(self) -> InteractionState:
        return {
            "interaction_patterns": {
                "typing_speed": self.calculate_typing_speed(),
                "pause_patterns": self.analyze_pause_patterns(),
                "interruption_frequency": self.get_interruption_rate(),
                "session_duration": self.get_session_duration()
            },
            
            "autoskip_behavior": {
                "successful_autoskips": self.count_successful_skips(),
                "manual_interruptions": self.count_interruptions(),
                "timeout_adjustments": self.get_timeout_history(),
                "user_satisfaction_signals": self.detect_satisfaction()
            },
            
            "error_encounters": {
                "user_reported_errors": self.get_user_reports(),
                "retry_attempts": self.count_retry_attempts(),
                "workaround_usage": self.detect_workarounds(),
                "abandonment_rate": self.calculate_abandonment()
            }
        }
    
    def detect_satisfaction(self):
        """Detecta sinais de satisfação/frustração do usuário"""
        signals = {
            "positive": [
                "continued_usage_after_autoskip",
                "no_immediate_manual_intervention",
                "consistent_timeout_preferences"
            ],
            "negative": [
                "frequent_manual_cancellations", 
                "rapid_timeout_changes",
                "immediate_retry_after_autoskip"
            ]
        }
        return self.analyze_signals(signals)
```

## 🐛 **Error Detection & Analysis**

### **1. Anomaly Detector**
```python
class AnomalyDetector:
    """Detecta anomalias e possíveis bugs automaticamente"""
    
    def __init__(self):
        self.models = {
            "performance_anomaly": PerformanceAnomalyModel(),
            "behavior_anomaly": BehaviorAnomalyModel(),
            "system_anomaly": SystemAnomalyModel()
        }
    
    async def detect_anomalies(self, context: BugContext) -> List[Anomaly]:
        anomalies = []
        
        # Performance anomalies
        if context.performance.response_time > self.baseline.response_time * 3:
            anomalies.append(Anomaly(
                type="performance_degradation",
                severity="high",
                description="Response time 3x above baseline",
                evidence=context.performance.get_evidence()
            ))
        
        # Behavior anomalies  
        if context.interactions.interruption_rate > 0.8:
            anomalies.append(Anomaly(
                type="high_interruption_rate",
                severity="medium", 
                description="User interrupting 80%+ of autoskips",
                evidence=context.interactions.get_evidence()
            ))
        
        # System anomalies
        if context.system.memory_usage > self.thresholds.memory_limit:
            anomalies.append(Anomaly(
                type="memory_leak",
                severity="critical",
                description="Memory usage exceeds safe limits",
                evidence=context.system.get_evidence()
            ))
        
        return anomalies
```

### **2. Root Cause Analyzer**
```python
class RootCauseAnalyzer:
    """Analisa causa raiz de problemas detectados"""
    
    def analyze_root_cause(self, anomalies: List[Anomaly], context: BugContext):
        analysis = RootCauseAnalysis()
        
        for anomaly in anomalies:
            potential_causes = self.get_potential_causes(anomaly)
            evidence = self.gather_evidence(potential_causes, context)
            likelihood = self.calculate_likelihood(evidence)
            
            analysis.add_hypothesis(
                cause=potential_causes,
                evidence=evidence,
                likelihood=likelihood,
                suggested_fixes=self.suggest_fixes(potential_causes)
            )
        
        return analysis.rank_by_likelihood()
    
    def suggest_fixes(self, causes):
        fix_database = {
            "memory_leak": [
                "restart_autoskip_process",
                "clear_cache_files", 
                "update_to_latest_version",
                "check_system_resources"
            ],
            
            "permission_denied": [
                "check_accessibility_permissions",
                "run_as_administrator",
                "verify_claude_settings_permissions",
                "reinstall_hooks"
            ],
            
            "process_not_found": [
                "verify_claude_code_installation",
                "check_process_name_patterns",
                "update_process_detection_logic",
                "manual_process_configuration"
            ]
        }
        
        return fix_database.get(causes[0], ["contact_support"])
```

## 📊 **Smart Bug Reporting**

### **1. Automated Bug Reporter**
```python
class SmartBugReporter:
    """Gera relatórios de bug inteligentes automaticamente"""
    
    async def generate_bug_report(self, anomaly: Anomaly, context: BugContext) -> BugReport:
        report = BugReport(
            id=self.generate_report_id(),
            timestamp=datetime.utcnow(),
            severity=anomaly.severity,
            title=self.generate_title(anomaly),
            description=self.generate_description(anomaly, context)
        )
        
        # Adiciona evidências
        report.evidence = await self.collect_evidence(anomaly, context)
        
        # Adiciona análise automática
        report.analysis = self.analyze_issue(anomaly, context)
        
        # Adiciona possíveis soluções
        report.suggested_fixes = self.suggest_solutions(anomaly, context)
        
        # Adiciona informações de reprodução
        report.reproduction_steps = self.generate_reproduction_steps(context)
        
        return report
    
    def generate_description(self, anomaly: Anomaly, context: BugContext) -> str:
        template = """
## 🐛 Issue Summary
{anomaly_description}

## 📊 System Context
- OS: {os_info}
- AutoSkipp Version: {version}
- Claude Code State: {claude_state}
- Browser: {browser_info}

## 🔍 Evidence
{evidence_details}

## 📈 Impact Assessment
{impact_analysis}

## 🛠️ Suggested Actions
{suggested_fixes}

## 📋 Reproduction Steps
{reproduction_steps}
        """
        
        return template.format(
            anomaly_description=anomaly.description,
            os_info=context.system.os_info,
            version=context.autoskip.version,
            claude_state=context.claude.health_summary,
            browser_info=context.browser.summary,
            evidence_details=self.format_evidence(anomaly.evidence),
            impact_analysis=self.assess_impact(anomaly, context),
            suggested_fixes=self.format_fixes(anomaly.suggested_fixes),
            reproduction_steps=self.format_reproduction_steps(context)
        )
```

### **2. User Feedback Integration**
```python
class UserFeedbackCollector:
    """Coleta feedback do usuário sobre bugs e sugestões"""
    
    async def collect_feedback(self, bug_report: BugReport) -> UserFeedback:
        feedback_ui = self.show_feedback_dialog(bug_report)
        
        return UserFeedback(
            report_id=bug_report.id,
            user_description=feedback_ui.get_user_description(),
            severity_rating=feedback_ui.get_severity_rating(),
            reproduction_confirmed=feedback_ui.get_reproduction_status(),
            additional_context=feedback_ui.get_additional_context(),
            contact_permission=feedback_ui.get_contact_permission()
        )
    
    def show_feedback_dialog(self, bug_report: BugReport):
        return FeedbackDialog(f"""
🐛 AutoSkipp detectou um possível problema:
{bug_report.title}

📋 Você pode nos ajudar?
• Este problema afetou seu trabalho?
• Você consegue reproduzir o problema?
• Há algo mais que devemos saber?

✅ Enviar relatório automaticamente?
[ ] Sim, incluir logs técnicos (anônimos)
[ ] Não, apenas registrar localmente
        """)
```

## 🔧 **CLI & User Interface**

### **Bug Reporting Commands**
```bash
# Verificação de saúde
$ autoskipp doctor
🩺 AutoSkipp Health Check
✅ System state: Healthy
⚠️  Claude Code: Process responsive but high memory usage
❌ Browser integration: Console errors detected

💡 3 issues found. Run 'autoskipp fix' for automatic repairs.

# Relatório de bug manual
$ autoskipp report-bug "AutoSkipp não detecta Claude Code"
🐛 Coletando informações...
📊 Analisando sistema...
🔍 Detectando anomalias...

📋 Relatório gerado: bug-report-20241127-001.json
🚀 Enviado para análise automática
💌 Feedback enviado aos desenvolvedores

# Logs detalhados
$ autoskipp logs --debug --last 1h
📋 AutoSkipp Debug Logs (última hora)

2024-11-27 14:30:15 [INFO] Hook execution started
2024-11-27 14:30:16 [WARN] Claude process detection timeout (2.1s)
2024-11-27 14:30:17 [ERROR] AppleScript execution failed: permission denied
2024-11-27 14:30:18 [INFO] Fallback to process monitoring
2024-11-27 14:30:20 [SUCCESS] AutoSkipp activated (3.2s)

# Análise de performance
$ autoskipp analyze --performance
📈 Performance Analysis (última semana)

🕐 Response Times:
   Average: 1.2s (target: <2s) ✅
   95th percentile: 3.1s (target: <5s) ✅  
   Outliers: 2 instances >10s ⚠️

🎯 Success Rates:
   Detection accuracy: 94% ✅
   Automation success: 91% ✅
   User satisfaction: 4.6/5 ✅

🐛 Error Patterns:
   Permission denied: 12% of failures
   Process not found: 8% of failures
   Timeout exceeded: 3% of failures
```

### **Integration Dashboard**
```bash
$ autoskipp dashboard
┌─────────────────────────────────────────────────────────────────────┐
│  🤖⏰ AutoSkipp Dashboard                          Status: Healthy ✅  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                     │
│  📊 Today's Stats                🐛 Issues                          │
│    • 47 successful autoskips      • 0 critical                     │
│    • 3 manual interruptions       • 2 warnings                     │
│    • 94% success rate             • 0 user reports                 │
│                                                                     │
│  ⚡ Performance                   🔍 Detection                      │
│    • Avg response: 1.1s           • Claude processes: 2 found      │
│    • Memory usage: 23MB           • Windows tracked: 1 active      │
│    • CPU usage: 0.1%              • Hooks status: All working      │
│                                                                     │
│  💡 Smart Insights                                                  │
│    • You prefer 3s timeouts during coding sessions                 │
│    • Performance is 15% better than last week                      │
│    • Consider enabling workflow templates for React projects       │
│                                                                     │
└─────────────────────────────────────────────────────────────────────┘

Press 'r' to refresh, 'l' for logs, 'h' for help, 'q' to quit
```

## 📤 **Data Export & Privacy**

### **Log Export**
```python
class LogExporter:
    """Exporta logs em vários formatos"""
    
    def export_logs(self, format: str, anonymize: bool = True):
        formats = {
            "json": self.export_json,
            "csv": self.export_csv, 
            "txt": self.export_text,
            "sqlite": self.export_database
        }
        
        raw_logs = self.collect_logs()
        
        if anonymize:
            processed_logs = self.anonymize_data(raw_logs)
        else:
            processed_logs = raw_logs
            
        return formats[format](processed_logs)
    
    def anonymize_data(self, logs):
        """Remove informações pessoais dos logs"""
        anonymizer = DataAnonymizer()
        return anonymizer.process(logs, rules=[
            "remove_file_paths",
            "hash_user_identifiers", 
            "remove_personal_data",
            "generalize_timestamps"
        ])
```

---

**Resultado:** AutoSkipp se torna ferramenta completa de **observabilidade e debugging** para o ecossistema Claude Code! 🐛🔍📊