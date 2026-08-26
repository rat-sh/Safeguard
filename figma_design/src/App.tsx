import { useState, type ReactNode } from "react";

// ─── Icons ────────────────────────────────────────────────────────────────────

const Icon = {
  Bell: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"/><path d="M13.73 21a2 2 0 0 1-3.46 0"/>
    </svg>
  ),
  User: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/><circle cx="12" cy="7" r="4"/>
    </svg>
  ),
  Home: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/><polyline points="9 22 9 12 15 12 15 22"/>
    </svg>
  ),
  AlertTriangle: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="m21.73 18-8-14a2 2 0 0 0-3.48 0l-8 14A2 2 0 0 0 4 21h16a2 2 0 0 0 1.73-3Z"/><line x1="12" x2="12" y1="9" y2="13"/><line x1="12" x2="12.01" y1="17" y2="17"/>
    </svg>
  ),
  History: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M3 3v5h5"/><path d="M3.05 13A9 9 0 1 0 6 5.3L3 8"/><path d="M12 7v5l4 2"/>
    </svg>
  ),
  Settings: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M12.22 2h-.44a2 2 0 0 0-2 2v.18a2 2 0 0 1-1 1.73l-.43.25a2 2 0 0 1-2 0l-.15-.08a2 2 0 0 0-2.73.73l-.22.38a2 2 0 0 0 .73 2.73l.15.1a2 2 0 0 1 1 1.72v.51a2 2 0 0 1-1 1.74l-.15.09a2 2 0 0 0-.73 2.73l.22.38a2 2 0 0 0 2.73.73l.15-.08a2 2 0 0 1 2 0l.43.25a2 2 0 0 1 1 1.73V20a2 2 0 0 0 2 2h.44a2 2 0 0 0 2-2v-.18a2 2 0 0 1 1-1.73l.43-.25a2 2 0 0 1 2 0l.15.08a2 2 0 0 0 2.73-.73l.22-.39a2 2 0 0 0-.73-2.73l-.15-.08a2 2 0 0 1-1-1.74v-.5a2 2 0 0 1 1-1.74l.15-.09a2 2 0 0 0 .73-2.73l-.22-.38a2 2 0 0 0-2.73-.73l-.15.08a2 2 0 0 1-2 0l-.43-.25a2 2 0 0 1-1-1.73V4a2 2 0 0 0-2-2z"/><circle cx="12" cy="12" r="3"/>
    </svg>
  ),
  Battery: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <rect width="16" height="10" x="2" y="7" rx="2" ry="2"/><line x1="22" x2="22" y1="11" y2="13"/>
    </svg>
  ),
  Phone: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M22 16.92v3a2 2 0 0 1-2.18 2 19.79 19.79 0 0 1-8.63-3.07A19.5 19.5 0 0 1 4.69 12 19.79 19.79 0 0 1 1.61 3.44 2 2 0 0 1 3.6 1.22h3a2 2 0 0 1 2 1.72 12.84 12.84 0 0 0 .7 2.81 2 2 0 0 1-.45 2.11L7.91 9a16 16 0 0 0 6.08 6.09l1.17-.97a2 2 0 0 1 2.1-.45 12.84 12.84 0 0 0 2.81.7A2 2 0 0 1 22 16.92z"/>
    </svg>
  ),
  ChevronRight: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="m9 18 6-6-6-6"/>
    </svg>
  ),
  ChevronLeft: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="m15 18-6-6 6-6"/>
    </svg>
  ),
  Plus: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <line x1="12" x2="12" y1="5" y2="19"/><line x1="5" x2="19" y1="12" y2="12"/>
    </svg>
  ),
  X: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M18 6 6 18"/><path d="m6 6 12 12"/>
    </svg>
  ),
  VolumeX: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <polygon points="11 5 6 9 2 9 2 15 6 15 11 19 11 5"/><line x1="23" x2="17" y1="9" y2="15"/><line x1="17" x2="23" y1="9" y2="15"/>
    </svg>
  ),
  Wifi: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M5 12.55a11 11 0 0 1 14.08 0"/><path d="M1.42 9a16 16 0 0 1 21.16 0"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><line x1="12" x2="12.01" y1="20" y2="20"/>
    </svg>
  ),
  WifiOff: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <line x1="1" x2="23" y1="1" y2="23"/><path d="M16.72 11.06A10.94 10.94 0 0 1 19 12.55"/><path d="M5 12.55a10.94 10.94 0 0 1 5.17-2.39"/><path d="M10.71 5.05A16 16 0 0 1 22.56 9"/><path d="M1.42 9a15.91 15.91 0 0 1 4.7-2.88"/><path d="M8.53 16.11a6 6 0 0 1 6.95 0"/><line x1="12" x2="12.01" y1="20" y2="20"/>
    </svg>
  ),
  Shield: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
    </svg>
  ),
  ShieldCheck: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/><path d="m9 12 2 2 4-4"/>
    </svg>
  ),
  Flame: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M8.5 14.5A2.5 2.5 0 0 0 11 12c0-1.38-.5-2-1-3-1.072-2.143-.224-4.054 2-6 .5 2.5 2 4.9 4 6.5 2 1.6 3 3.5 3 5.5a7 7 0 1 1-14 0c0-1.153.433-2.294 1-3a2.5 2.5 0 0 0 2.5 2.5z"/>
    </svg>
  ),
  Info: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <circle cx="12" cy="12" r="10"/><path d="M12 16v-4"/><path d="M12 8h.01"/>
    </svg>
  ),
  Check: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2.5} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M20 6 9 17l-5-5"/>
    </svg>
  ),
  Clock: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <circle cx="12" cy="12" r="10"/><polyline points="12 6 12 12 16 14"/>
    </svg>
  ),
  Edit: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/>
    </svg>
  ),
  Trash: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <polyline points="3 6 5 6 21 6"/><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/>
    </svg>
  ),
  Power: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M18.36 6.64a9 9 0 1 1-12.73 0"/><line x1="12" x2="12" y1="2" y2="12"/>
    </svg>
  ),
  LogOut: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" x2="9" y1="12" y2="12"/>
    </svg>
  ),
  HelpCircle: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <circle cx="12" cy="12" r="10"/><path d="M9.09 9a3 3 0 0 1 5.83 1c0 2-3 3-3 3"/><line x1="12" x2="12.01" y1="17" y2="17"/>
    </svg>
  ),
  Lock: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <rect width="18" height="11" x="3" y="11" rx="2" ry="2"/><path d="M7 11V7a5 5 0 0 1 10 0v4"/>
    </svg>
  ),
  Zap: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"/>
    </svg>
  ),
  MapPin: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M20 10c0 6-8 12-8 12s-8-6-8-12a8 8 0 0 1 16 0Z"/><circle cx="12" cy="10" r="3"/>
    </svg>
  ),
  RefreshCw: () => (
    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth={2} strokeLinecap="round" strokeLinejoin="round" className="w-full h-full">
      <path d="M3 12a9 9 0 0 1 9-9 9.75 9.75 0 0 1 6.74 2.74L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 0 1-9 9 9.75 9.75 0 0 1-6.74-2.74L3 16"/><path d="M8 16H3v5"/>
    </svg>
  ),
};

// ─── Types ────────────────────────────────────────────────────────────────────
type Screen =
  | "splash" | "login" | "otp" | "home" | "alerts" | "alert-detail"
  | "history" | "settings" | "add-contact" | "quiet-hours" | "profile"
  | "empty-states" | "loading" | "error";

// ─── Shared Components ────────────────────────────────────────────────────────

function StatusBar() {
  return (
    <div className="flex items-center justify-between px-5 pt-3 pb-1">
      <span className="text-xs font-semibold text-[#0F172A]">9:41</span>
      <div className="flex items-center gap-1.5">
        <div className="flex gap-0.5 items-end h-3">
          {[2, 3, 4, 4].map((h, i) => (
            <div key={i} style={{ height: `${h * 3}px` }} className="w-1 rounded-sm bg-[#0F172A]" />
          ))}
        </div>
        <div className="w-4 h-3">
          <Icon.Wifi />
        </div>
        <div className="flex items-center gap-0.5">
          <div className="w-5 h-2.5 rounded-sm border border-[#0F172A] relative overflow-hidden p-px">
            <div className="h-full w-3/4 bg-[#0F172A] rounded-xs" />
          </div>
          <div className="w-0.5 h-1.5 rounded-r-sm bg-[#0F172A]" />
        </div>
      </div>
    </div>
  );
}

function AppBar({ title, onBack, onNotif, onProfile, navigate }: {
  title: string; onBack?: () => void;
  onNotif?: () => void; onProfile?: () => void;
  navigate?: (s: Screen) => void;
}) {
  return (
    <div className="flex items-center justify-between px-5 py-3 bg-white border-b border-[#E2E8F0]">
      {onBack ? (
        <button onClick={onBack} className="w-10 h-10 flex items-center justify-center -ml-2 text-[#0F172A]">
          <div className="w-5 h-5"><Icon.ChevronLeft /></div>
        </button>
      ) : (
        <span className="text-xl font-bold text-[#0F766E] tracking-tight">{title}</span>
      )}
      {onBack && <span className="text-lg font-semibold text-[#0F172A]">{title}</span>}
      <div className="flex items-center gap-2">
        {onNotif && (
          <button onClick={onNotif} className="w-10 h-10 flex items-center justify-center text-[#0F172A] relative">
            <div className="w-5 h-5"><Icon.Bell /></div>
            <span className="absolute top-2 right-2 w-2 h-2 bg-[#DC2626] rounded-full border border-white" />
          </button>
        )}
        {onProfile && (
          <button onClick={onProfile} className="w-8 h-8 rounded-full bg-[#0F766E] flex items-center justify-center text-white text-sm font-semibold">
            RK
          </button>
        )}
        {onBack && <div className="w-10" />}
      </div>
    </div>
  );
}

function BottomNav({ active, navigate }: { active: "home" | "alerts" | "history" | "settings"; navigate: (s: Screen) => void }) {
  const items = [
    { id: "home" as Screen, label: "Home", icon: Icon.Home },
    { id: "alerts" as Screen, label: "Alerts", icon: Icon.AlertTriangle },
    { id: "history" as Screen, label: "History", icon: Icon.History },
    { id: "settings" as Screen, label: "Settings", icon: Icon.Settings },
  ];
  return (
    <div className="flex bg-white border-t border-[#E2E8F0] pb-safe">
      {items.map(({ id, label, icon: Ic }) => {
        const isActive = active === id;
        return (
          <button key={id} onClick={() => navigate(id)} className="flex-1 flex flex-col items-center py-2 gap-0.5 min-h-[56px] justify-center">
            <div className={`w-6 h-6 ${isActive ? "text-[#0F766E]" : "text-[#94A3B8]"}`}><Ic /></div>
            <span className={`text-[10px] font-medium ${isActive ? "text-[#0F766E]" : "text-[#94A3B8]"}`}>{label}</span>
          </button>
        );
      })}
    </div>
  );
}

function Card({ children, className = "" }: { children: ReactNode; className?: string }) {
  return (
    <div className={`bg-white rounded-2xl shadow-[0_1px_8px_0_rgba(15,23,42,0.06)] ${className}`}>
      {children}
    </div>
  );
}

function Toggle({ value, onChange }: { value: boolean; onChange: (v: boolean) => void }) {
  return (
    <button
      onClick={() => onChange(!value)}
      className={`relative w-11 h-6 rounded-full transition-colors duration-200 ${value ? "bg-[#0F766E]" : "bg-[#CBD5E1]"}`}
    >
      <span className={`absolute top-0.5 left-0.5 w-5 h-5 bg-white rounded-full shadow-sm transition-transform duration-200 ${value ? "translate-x-5" : "translate-x-0"}`} />
    </button>
  );
}

// ─── 1. Splash Screen ─────────────────────────────────────────────────────────
function SplashScreen({ navigate }: { navigate: (s: Screen) => void }) {
  return (
    <div className="flex flex-col items-center justify-center h-full bg-gradient-to-b from-[#0F766E] to-[#134E4A] px-8">
      {/* Abstract cylinder illustration */}
      <div className="relative mb-8">
        <div className="w-32 h-32 rounded-full bg-white/10 flex items-center justify-center">
          <div className="w-24 h-24 rounded-full bg-white/15 flex items-center justify-center">
            <div className="w-16 h-16 rounded-full bg-white/20 flex items-center justify-center">
              {/* Cylinder + Shield */}
              <div className="relative">
                <svg viewBox="0 0 64 64" className="w-14 h-14" fill="none">
                  {/* Cylinder body */}
                  <rect x="18" y="20" width="28" height="32" rx="4" fill="rgba(255,255,255,0.15)" stroke="rgba(255,255,255,0.5)" strokeWidth="1.5"/>
                  {/* Cylinder top ellipse */}
                  <ellipse cx="32" cy="20" rx="14" ry="5" fill="rgba(255,255,255,0.2)" stroke="rgba(255,255,255,0.6)" strokeWidth="1.5"/>
                  {/* Valve */}
                  <rect x="27" y="13" width="10" height="7" rx="2" fill="rgba(255,255,255,0.3)" stroke="rgba(255,255,255,0.7)" strokeWidth="1.5"/>
                  {/* Shield overlay */}
                  <path d="M32 28l-8 3v5c0 4 3.5 7 8 8.5C37.5 43 41 40 41 36v-5l-9-3z" fill="rgba(255,255,255,0.9)" />
                  {/* Check in shield */}
                  <path d="M28.5 36l2.5 2.5 5-5" stroke="#0F766E" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round"/>
                </svg>
              </div>
            </div>
          </div>
        </div>
        {/* Orbiting dot */}
        <div className="absolute top-3 right-3 w-3 h-3 bg-[#34D399] rounded-full shadow-lg" />
        <div className="absolute bottom-4 left-2 w-2 h-2 bg-white/40 rounded-full" />
      </div>

      <h1 className="text-4xl font-bold text-white tracking-tight mb-2">SafeLPG</h1>
      <p className="text-[#99F6E4] text-center text-[15px] leading-snug mb-12">
        Intelligent LPG Safety{"\n"}for Your Home
      </p>

      {/* Progress dots */}
      <div className="flex gap-2 mb-16">
        {[0,1,2].map(i => (
          <div key={i} className={`h-1.5 rounded-full transition-all ${i === 0 ? "w-6 bg-white" : "w-1.5 bg-white/30"}`} />
        ))}
      </div>

      <button onClick={() => navigate("login")} className="w-full py-4 bg-white rounded-xl text-[#0F766E] font-semibold text-[17px] shadow-lg">
        Get Started
      </button>
      <p className="text-white/50 text-xs mt-6">Version 2.1.0 · Certified Safety Grade A</p>
    </div>
  );
}

// ─── 2. Login Screen ──────────────────────────────────────────────────────────
function LoginScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [phone, setPhone] = useState("98765 43210");
  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <StatusBar />
      <div className="flex flex-col flex-1 px-6 pt-6 pb-8">
        {/* Logo row */}
        <div className="flex items-center gap-2 mb-10">
          <div className="w-8 h-8 text-[#0F766E]"><Icon.ShieldCheck /></div>
          <span className="text-xl font-bold text-[#0F766E]">SafeLPG</span>
        </div>

        <h2 className="text-[26px] font-bold text-[#0F172A] mb-1">Welcome back</h2>
        <p className="text-[#64748B] text-[15px] mb-10">Enter your mobile number to continue</p>

        <label className="text-[13px] font-medium text-[#0F172A] mb-1.5 block">Mobile Number</label>
        <div className="flex items-center border border-[#E2E8F0] rounded-xl bg-white overflow-hidden mb-3 focus-within:border-[#0F766E] focus-within:ring-2 focus-within:ring-[#0F766E]/10 transition-all">
          <div className="flex items-center gap-2 px-4 py-4 border-r border-[#E2E8F0] bg-[#F8FAFC]">
            <span className="text-[15px] text-[#0F172A] font-medium">🇮🇳</span>
            <span className="text-[15px] text-[#0F172A] font-medium">+91</span>
            <div className="w-3 h-3 text-[#64748B]"><Icon.ChevronRight /></div>
          </div>
          <input
            type="tel"
            value={phone}
            onChange={e => setPhone(e.target.value)}
            className="flex-1 px-4 py-4 text-[15px] text-[#0F172A] outline-none bg-transparent"
            placeholder="98765 43210"
          />
        </div>

        <p className="text-[13px] text-[#64748B] mb-8">
          We will send a 6-digit OTP to verify your identity. Standard SMS rates may apply.
        </p>

        <button onClick={() => navigate("otp")} className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[17px] shadow-sm active:bg-[#134E4A] transition-colors">
          Send OTP
        </button>

        <div className="flex-1" />

        <p className="text-center text-[13px] text-[#64748B]">
          By continuing, you agree to our{" "}
          <span className="text-[#0F766E] font-medium">Terms of Service</span>
          {" "}and{" "}
          <span className="text-[#0F766E] font-medium">Privacy Policy</span>
        </p>
      </div>
    </div>
  );
}

// ─── 3. OTP Screen ───────────────────────────────────────────────────────────
function OTPScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [otp, setOtp] = useState(["4", "2", "7", "1", "", ""]);
  const [timer, setTimer] = useState(42);

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <StatusBar />
      <div className="px-6 pt-4">
        <button onClick={() => navigate("login")} className="w-10 h-10 flex items-center justify-center -ml-2 text-[#0F172A]">
          <div className="w-5 h-5"><Icon.ChevronLeft /></div>
        </button>
      </div>
      <div className="flex flex-col flex-1 px-6 pt-4 pb-8">
        <div className="w-14 h-14 rounded-2xl bg-[#CCFBF1] flex items-center justify-center mb-6">
          <div className="w-7 h-7 text-[#0F766E]"><Icon.Phone /></div>
        </div>

        <h2 className="text-[24px] font-bold text-[#0F172A] mb-1">Verify your number</h2>
        <p className="text-[#64748B] text-[15px] mb-8">
          Enter the 6-digit code sent to{" "}
          <span className="font-semibold text-[#0F172A]">+91 98765 43210</span>
        </p>

        {/* OTP boxes */}
        <div className="flex gap-3 mb-4 justify-center">
          {otp.map((digit, i) => (
            <div key={i} className={`w-12 h-14 rounded-xl flex items-center justify-center text-[22px] font-bold border-2 transition-colors ${digit ? "border-[#0F766E] bg-white text-[#0F172A]" : "border-[#E2E8F0] bg-white text-[#94A3B8]"}`}>
              {digit || "·"}
            </div>
          ))}
        </div>

        {/* Timer */}
        <div className="flex items-center justify-center gap-1 mb-8">
          <div className="w-3.5 h-3.5 text-[#64748B]"><Icon.Clock /></div>
          {timer > 0 ? (
            <span className="text-[13px] text-[#64748B]">Resend OTP in <span className="font-semibold text-[#0F172A]">0:{timer.toString().padStart(2, "0")}</span></span>
          ) : (
            <button className="text-[13px] text-[#0F766E] font-semibold">Resend OTP</button>
          )}
        </div>

        <button onClick={() => navigate("home")} className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[17px] shadow-sm">
          Verify & Continue
        </button>

        <p className="text-center text-[13px] text-[#64748B] mt-4">
          Having trouble?{" "}
          <span className="text-[#0F766E] font-medium">Contact support</span>
        </p>
      </div>
    </div>
  );
}

// ─── 4. Home Dashboard ────────────────────────────────────────────────────────
function HomeScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const gasLevel = 18;
  const gasColor = gasLevel < 10 ? "#16A34A" : gasLevel < 25 ? "#D97706" : gasLevel < 40 ? "#EA580C" : "#DC2626";
  const gasBg = gasLevel < 10 ? "#DCFCE7" : gasLevel < 25 ? "#FEF3C7" : gasLevel < 40 ? "#FFEDD5" : "#FEE2E2";
  const gasLabel = gasLevel < 10 ? "Safe" : gasLevel < 25 ? "Caution" : gasLevel < 40 ? "Warning" : "Critical";

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <div className="flex items-center justify-between px-5 py-3">
          <span className="text-xl font-bold text-[#0F766E] tracking-tight">SafeLPG</span>
          <div className="flex items-center gap-1">
            <button onClick={() => navigate("alerts")} className="w-10 h-10 flex items-center justify-center text-[#0F172A] relative">
              <div className="w-5 h-5"><Icon.Bell /></div>
              <span className="absolute top-2 right-2 w-2 h-2 bg-[#DC2626] rounded-full border border-white" />
            </button>
            <button onClick={() => navigate("profile")} className="w-8 h-8 rounded-full bg-[#0F766E] flex items-center justify-center text-white text-sm font-semibold">
              RK
            </button>
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
        {/* Gas Level Card */}
        <Card className="p-5">
          <div className="flex items-start justify-between mb-4">
            <div>
              <p className="text-[13px] text-[#64748B] font-medium uppercase tracking-wider">Gas Concentration</p>
              <p className="text-[12px] text-[#64748B]">Cylinder A · Kitchen</p>
            </div>
            <span className="px-3 py-1 rounded-full text-[12px] font-semibold" style={{ background: gasBg, color: gasColor }}>
              {gasLabel}
            </span>
          </div>
          {/* Arc gauge */}
          <div className="flex flex-col items-center py-2">
            <div className="relative w-44 h-24 overflow-hidden">
              <svg viewBox="0 0 176 96" className="w-full h-full">
                <path d="M 16 88 A 72 72 0 0 1 160 88" fill="none" stroke="#E2E8F0" strokeWidth="12" strokeLinecap="round"/>
                <path
                  d="M 16 88 A 72 72 0 0 1 160 88"
                  fill="none"
                  stroke={gasColor}
                  strokeWidth="12"
                  strokeLinecap="round"
                  strokeDasharray={`${(gasLevel / 100) * 226} 226`}
                />
              </svg>
              <div className="absolute inset-0 flex flex-col items-center justify-end pb-1">
                <span className="text-[40px] font-bold leading-none" style={{ color: gasColor }}>{gasLevel}</span>
                <span className="text-[13px] text-[#64748B] font-medium">Current LEL %</span>
              </div>
            </div>
          </div>

          {/* Status strip */}
          <div className="grid grid-cols-4 gap-2 mt-4">
            {[
              { label: "Regulator", value: "ON", color: "#16A34A", bg: "#DCFCE7" },
              { label: "Presence", value: "Detected", color: "#0F766E", bg: "#CCFBF1" },
              { label: "Battery", value: "76%", color: "#D97706", bg: "#FEF3C7" },
              { label: "Updated", value: "12s ago", color: "#64748B", bg: "#F1F5F9" },
            ].map(item => (
              <div key={item.label} className="rounded-xl p-2 flex flex-col items-center gap-0.5" style={{ background: item.bg }}>
                <span className="text-[11px] font-semibold" style={{ color: item.color }}>{item.value}</span>
                <span className="text-[10px] text-[#64748B]">{item.label}</span>
              </div>
            ))}
          </div>
        </Card>

        {/* System State */}
        <Card className="p-4">
          <div className="flex items-center justify-between">
            <div className="flex items-center gap-3">
              <div className="w-10 h-10 rounded-xl bg-[#FEF3C7] flex items-center justify-center">
                <div className="w-5 h-5 text-[#D97706]"><Icon.AlertTriangle /></div>
              </div>
              <div>
                <p className="text-[13px] text-[#64748B]">System State</p>
                <p className="text-[17px] font-bold text-[#D97706]">Caution</p>
              </div>
            </div>
            <div className="text-right">
              <p className="text-[12px] text-[#64748B]">Since</p>
              <p className="text-[13px] font-semibold text-[#0F172A]">10:42 AM</p>
            </div>
          </div>
          <div className="mt-3 h-1.5 bg-[#E2E8F0] rounded-full overflow-hidden">
            <div className="h-full bg-[#D97706] rounded-full" style={{ width: "35%" }} />
          </div>
          <p className="text-[12px] text-[#64748B] mt-1.5">Gas level slightly elevated — ventilate the area</p>
        </Card>

        {/* Quick Actions */}
        <div className="grid grid-cols-3 gap-3">
          {[
            { label: "Silence Alert", icon: Icon.VolumeX, color: "#0F766E", bg: "#CCFBF1" },
            { label: "Emergency", icon: Icon.Phone, color: "#DC2626", bg: "#FEE2E2" },
            { label: "View History", icon: Icon.History, color: "#0F172A", bg: "#F1F5F9" },
          ].map(({ label, icon: Ic, color, bg }) => (
            <button
              key={label}
              onClick={() => label === "View History" ? navigate("history") : label === "Emergency" ? navigate("alert-detail") : undefined}
              className="rounded-2xl p-4 flex flex-col items-center gap-2 shadow-[0_1px_8px_0_rgba(15,23,42,0.06)] active:scale-95 transition-transform"
              style={{ background: "#fff" }}
            >
              <div className="w-10 h-10 rounded-xl flex items-center justify-center" style={{ background: bg }}>
                <div className="w-5 h-5" style={{ color }}><Ic /></div>
              </div>
              <span className="text-[11px] font-semibold text-[#0F172A] text-center leading-tight">{label}</span>
            </button>
          ))}
        </div>

        {/* Recent Activity */}
        <Card className="p-4">
          <div className="flex items-center justify-between mb-3">
            <span className="text-[15px] font-semibold text-[#0F172A]">Recent Activity</span>
            <button onClick={() => navigate("history")} className="text-[13px] text-[#0F766E] font-medium">See all</button>
          </div>
          {[
            { time: "10:42 AM", text: "Gas level rose above 15% LEL", dot: "#D97706" },
            { time: "09:15 AM", text: "System check passed — all normal", dot: "#16A34A" },
            { time: "08:30 AM", text: "Morning safety scan completed", dot: "#0F766E" },
          ].map((item, i) => (
            <div key={i} className="flex items-start gap-3 py-2.5 border-b border-[#F1F5F9] last:border-0">
              <div className="w-2 h-2 rounded-full mt-1.5 flex-shrink-0" style={{ background: item.dot }} />
              <div className="flex-1 min-w-0">
                <p className="text-[14px] text-[#0F172A]">{item.text}</p>
              </div>
              <span className="text-[12px] text-[#94A3B8] flex-shrink-0">{item.time}</span>
            </div>
          ))}
        </Card>
      </div>

      <BottomNav active="home" navigate={navigate} />
    </div>
  );
}

// ─── 5. Alert Centre ──────────────────────────────────────────────────────────
function AlertsScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [filter, setFilter] = useState("All");
  const filters = ["All", "Critical", "Warning", "Info"];
  const alerts = [
    { severity: "critical", title: "High Gas Concentration", desc: "Regulator OFF + Gas level above 25% LEL. Immediate action required.", time: "10:42 AM", color: "#DC2626", bg: "#FEE2E2" },
    { severity: "warning", title: "Regulator Switched Off", desc: "Gas regulator turned OFF while presence is detected in the kitchen.", time: "09:58 AM", color: "#D97706", bg: "#FEF3C7" },
    { severity: "warning", title: "Battery Low", desc: "Device battery at 18%. Connect to power source to avoid service interruption.", time: "08:30 AM", color: "#D97706", bg: "#FEF3C7" },
    { severity: "info", title: "Morning Safety Check", desc: "Automated daily safety scan completed. No anomalies found.", time: "07:00 AM", color: "#0F766E", bg: "#CCFBF1" },
  ];
  const filtered = filter === "All" ? alerts : alerts.filter(a => a.severity === filter.toLowerCase());

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <div className="px-5 py-3">
          <h1 className="text-xl font-bold text-[#0F172A]">Alert Centre</h1>
          <p className="text-[13px] text-[#64748B]">3 active alerts today</p>
        </div>
        {/* Filters */}
        <div className="flex gap-2 px-5 pb-3 overflow-x-auto">
          {filters.map(f => (
            <button
              key={f}
              onClick={() => setFilter(f)}
              className={`px-4 py-1.5 rounded-full text-[13px] font-medium whitespace-nowrap transition-colors ${filter === f ? "bg-[#0F766E] text-white" : "bg-[#F1F5F9] text-[#64748B]"}`}
            >
              {f}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3">
        {filtered.map((alert, i) => (
          <button key={i} onClick={() => navigate("alert-detail")} className="w-full text-left">
            <Card className="overflow-hidden">
              <div className="flex">
                <div className="w-1 flex-shrink-0 rounded-l-2xl" style={{ background: alert.color }} />
                <div className="flex-1 p-4">
                  <div className="flex items-start justify-between mb-1.5">
                    <div className="flex items-center gap-2">
                      <span className="px-2.5 py-0.5 rounded-full text-[11px] font-semibold uppercase tracking-wide" style={{ background: alert.bg, color: alert.color }}>
                        {alert.severity}
                      </span>
                    </div>
                    <span className="text-[12px] text-[#94A3B8]">{alert.time}</span>
                  </div>
                  <h3 className="text-[15px] font-semibold text-[#0F172A] mb-1">{alert.title}</h3>
                  <p className="text-[13px] text-[#64748B] leading-snug mb-3">{alert.desc}</p>
                  <div className="flex gap-2">
                    <button className="flex-1 py-2 border border-[#E2E8F0] rounded-lg text-[13px] font-medium text-[#64748B]">
                      Mark as False
                    </button>
                    <button className="flex-1 py-2 border border-[#0F766E] rounded-lg text-[13px] font-medium text-[#0F766E]">
                      Silence 15 min
                    </button>
                  </div>
                </div>
              </div>
            </Card>
          </button>
        ))}
      </div>

      <BottomNav active="alerts" navigate={navigate} />
    </div>
  );
}

// ─── 6. Alert Detail ──────────────────────────────────────────────────────────
function AlertDetailScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const timeline = [
    { time: "10:42:03", action: "Gas level threshold exceeded (25% LEL)", icon: Icon.AlertTriangle, color: "#DC2626" },
    { time: "10:42:05", action: "Push notification dispatched to your device", icon: Icon.Bell, color: "#D97706" },
    { time: "10:42:10", action: "SMS alert sent to Riya Kumar (+91 98765 XXXXX)", icon: Icon.Phone, color: "#D97706" },
    { time: "10:42:25", action: "Voice call attempted to emergency contact #1", icon: Icon.Phone, color: "#0F766E" },
    { time: "10:42:40", action: "Alert acknowledged — awaiting user response", icon: Icon.Clock, color: "#64748B" },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Alert Details" onBack={() => navigate("alerts")} />
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        {/* Severity Header */}
        <Card className="p-4 border-l-4 border-[#DC2626]">
          <div className="flex items-start gap-3">
            <div className="w-12 h-12 rounded-xl bg-[#FEE2E2] flex items-center justify-center flex-shrink-0">
              <div className="w-6 h-6 text-[#DC2626]"><Icon.AlertTriangle /></div>
            </div>
            <div className="flex-1">
              <div className="flex items-center gap-2 mb-1">
                <span className="px-2.5 py-0.5 rounded-full text-[11px] font-bold bg-[#FEE2E2] text-[#DC2626] uppercase tracking-wider">Critical</span>
                <span className="text-[12px] text-[#94A3B8]">10:42 AM · Today</span>
              </div>
              <h2 className="text-[17px] font-bold text-[#0F172A]">High Gas Concentration Detected</h2>
            </div>
          </div>
        </Card>

        {/* Explanation */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-2">Why was this triggered?</h3>
          <p className="text-[14px] text-[#64748B] leading-relaxed">
            The gas sensor detected a concentration of <span className="font-semibold text-[#DC2626]">28.4% LEL</span> (Lower Explosive Limit), which is above the critical threshold of 25% LEL. Combined with the regulator being switched OFF, this indicates a potential gas leak.
          </p>
          <div className="mt-3 grid grid-cols-2 gap-2">
            {[
              { label: "Peak Level", value: "28.4% LEL", color: "#DC2626" },
              { label: "Duration", value: "18 minutes", color: "#D97706" },
              { label: "Regulator", value: "OFF", color: "#DC2626" },
              { label: "Presence", value: "Detected", color: "#D97706" },
            ].map(item => (
              <div key={item.label} className="bg-[#F8FAFC] rounded-lg p-2.5">
                <p className="text-[11px] text-[#64748B]">{item.label}</p>
                <p className="text-[14px] font-semibold" style={{ color: item.color }}>{item.value}</p>
              </div>
            ))}
          </div>
        </Card>

        {/* Timeline */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-4">Actions Taken</h3>
          <div className="space-y-4">
            {timeline.map((item, i) => (
              <div key={i} className="flex gap-3">
                <div className="flex flex-col items-center">
                  <div className="w-8 h-8 rounded-full flex items-center justify-center flex-shrink-0" style={{ background: `${item.color}15` }}>
                    <div className="w-4 h-4" style={{ color: item.color }}><item.icon /></div>
                  </div>
                  {i < timeline.length - 1 && <div className="w-px flex-1 bg-[#E2E8F0] mt-1" />}
                </div>
                <div className="flex-1 pb-4">
                  <p className="text-[12px] text-[#94A3B8] mb-0.5">{item.time}</p>
                  <p className="text-[13px] text-[#0F172A]">{item.action}</p>
                </div>
              </div>
            ))}
          </div>
        </Card>
      </div>

      {/* Action Buttons */}
      <div className="bg-white border-t border-[#E2E8F0] px-4 py-4 space-y-2">
        <button className="w-full py-3.5 bg-[#DC2626] rounded-xl text-white font-semibold text-[16px]">
          📞 Call Emergency Services
        </button>
        <div className="flex gap-2">
          <button className="flex-1 py-3 border border-[#E2E8F0] rounded-xl text-[14px] font-medium text-[#64748B]">
            Mark False Alarm
          </button>
          <button className="flex-1 py-3 border border-[#0F766E] rounded-xl text-[14px] font-medium text-[#0F766E]">
            Silence 15 min
          </button>
        </div>
      </div>
    </div>
  );
}

// ─── 7. History ───────────────────────────────────────────────────────────────
function HistoryScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [tab, setTab] = useState("Week");

  const chartPoints = [12, 8, 15, 22, 18, 10, 14, 19, 16, 11, 9, 18, 24, 17];
  const maxVal = 30;
  const w = 320; const h = 100; const pts = chartPoints.length;
  const toX = (i: number) => (i / (pts - 1)) * (w - 20) + 10;
  const toY = (v: number) => h - (v / maxVal) * (h - 10) - 5;
  const polyline = chartPoints.map((v, i) => `${toX(i)},${toY(v)}`).join(" ");
  const area = `M ${toX(0)},${h} ${chartPoints.map((v, i) => `L ${toX(i)},${toY(v)}`).join(" ")} L ${toX(pts - 1)},${h} Z`;

  const events = [
    { date: "Today", time: "10:42 AM", desc: "Critical: Gas exceeded 25% LEL", dot: "#DC2626" },
    { date: "Today", time: "09:15 AM", desc: "Warning: Regulator switched off", dot: "#D97706" },
    { date: "Yesterday", time: "07:00 PM", desc: "Info: Daily safety check passed", dot: "#16A34A" },
    { date: "Yesterday", time: "12:30 PM", desc: "Info: Safe cooking session — 45 min", dot: "#16A34A" },
    { date: "Aug 23", time: "08:15 AM", desc: "Warning: Battery below 20%", dot: "#D97706" },
    { date: "Aug 22", time: "06:00 PM", desc: "Info: Safe cooking session — 30 min", dot: "#16A34A" },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <div className="px-5 py-3">
          <h1 className="text-xl font-bold text-[#0F172A]">History & Insights</h1>
        </div>
        {/* Segmented control */}
        <div className="px-5 pb-3">
          <div className="flex bg-[#F1F5F9] rounded-xl p-1">
            {["Day", "Week", "Month"].map(t => (
              <button key={t} onClick={() => setTab(t)} className={`flex-1 py-2 rounded-lg text-[14px] font-semibold transition-all ${tab === t ? "bg-white text-[#0F766E] shadow-sm" : "text-[#64748B]"}`}>
                {t}
              </button>
            ))}
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3">
        {/* Chart */}
        <Card className="p-4">
          <div className="flex items-center justify-between mb-3">
            <div>
              <p className="text-[13px] text-[#64748B]">Gas Level (% LEL)</p>
              <p className="text-[15px] font-semibold text-[#0F172A]">7-day overview</p>
            </div>
            <div className="flex items-center gap-1">
              <div className="w-2 h-2 rounded-full bg-[#0F766E]" />
              <span className="text-[12px] text-[#64748B]">LEL %</span>
            </div>
          </div>
          <svg viewBox={`0 0 ${w} ${h + 20}`} className="w-full" style={{ height: 100 }}>
            <defs>
              <linearGradient id="areaGrad" x1="0" y1="0" x2="0" y2="1">
                <stop offset="0%" stopColor="#0F766E" stopOpacity="0.15"/>
                <stop offset="100%" stopColor="#0F766E" stopOpacity="0"/>
              </linearGradient>
            </defs>
            {/* Grid lines */}
            {[0, 10, 20, 30].map(v => (
              <line key={v} x1="10" x2={w-10} y1={toY(v)} y2={toY(v)} stroke="#E2E8F0" strokeWidth="1" strokeDasharray="4,4"/>
            ))}
            <path d={area} fill="url(#areaGrad)"/>
            <polyline points={polyline} fill="none" stroke="#0F766E" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round"/>
            {/* Highlight point */}
            <circle cx={toX(4)} cy={toY(18)} r="4" fill="#0F766E"/>
            <circle cx={toX(4)} cy={toY(18)} r="7" fill="#0F766E" opacity="0.15"/>
            {/* Labels */}
            {["M","T","W","T","F","S","S"].map((d, i) => (
              <text key={i} x={toX(Math.round(i*(pts-1)/6))} y={h+16} textAnchor="middle" fontSize="9" fill="#94A3B8">{d}</text>
            ))}
          </svg>
        </Card>

        {/* Summary cards */}
        <div className="grid grid-cols-3 gap-3">
          {[
            { label: "Total Alerts", value: "9", change: "+3", color: "#DC2626", bg: "#FEE2E2" },
            { label: "False Alarms Prevented", value: "4", change: "-1", color: "#D97706", bg: "#FEF3C7" },
            { label: "Safe Cooking Sessions", value: "14", change: "+2", color: "#16A34A", bg: "#DCFCE7" },
          ].map(item => (
            <Card key={item.label} className="p-3">
              <div className="w-7 h-7 rounded-lg flex items-center justify-center mb-2" style={{ background: item.bg }}>
                <div className="w-3.5 h-3.5" style={{ color: item.color }}><Icon.ShieldCheck /></div>
              </div>
              <p className="text-[20px] font-bold text-[#0F172A]">{item.value}</p>
              <p className="text-[10px] text-[#64748B] leading-tight">{item.label}</p>
              <p className="text-[10px] font-medium mt-0.5" style={{ color: item.color }}>{item.change} this week</p>
            </Card>
          ))}
        </div>

        {/* Event list */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-3">Event Log</h3>
          {events.map((e, i) => {
            const showDate = i === 0 || events[i - 1].date !== e.date;
            return (
              <div key={i}>
                {showDate && <p className="text-[12px] font-semibold text-[#94A3B8] uppercase tracking-wider mt-2 mb-1.5">{e.date}</p>}
                <div className="flex items-center gap-3 py-2.5 border-b border-[#F8FAFC] last:border-0">
                  <div className="w-2 h-2 rounded-full flex-shrink-0" style={{ background: e.dot }} />
                  <p className="flex-1 text-[14px] text-[#0F172A]">{e.desc}</p>
                  <span className="text-[12px] text-[#94A3B8]">{e.time}</span>
                </div>
              </div>
            );
          })}
        </Card>
      </div>

      <BottomNav active="history" navigate={navigate} />
    </div>
  );
}

// ─── 8. Device Settings ────────────────────────────────────────────────────────
function SettingsScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [notifs, setNotifs] = useState({ push: true, sms: true, voice: false, quiet: false });
  const contacts = [
    { name: "Riya Kumar", phone: "+91 98765 43210", priority: 1 },
    { name: "Arjun Sharma", phone: "+91 87654 32109", priority: 2 },
  ];

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <div className="px-5 py-3">
          <h1 className="text-xl font-bold text-[#0F172A]">Settings</h1>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-3 space-y-3">
        {/* Emergency Contacts */}
        <Card className="p-4">
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-[15px] font-semibold text-[#0F172A]">Emergency Contacts</h3>
            <button onClick={() => navigate("add-contact")} className="flex items-center gap-1 text-[13px] text-[#0F766E] font-medium">
              <div className="w-4 h-4"><Icon.Plus /></div> Add
            </button>
          </div>
          {contacts.map((c, i) => (
            <div key={i} className="flex items-center gap-3 py-2.5 border-b border-[#F8FAFC] last:border-0">
              <div className="w-9 h-9 rounded-full bg-[#CCFBF1] flex items-center justify-center flex-shrink-0">
                <span className="text-[14px] font-bold text-[#0F766E]">{c.priority}</span>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[14px] font-semibold text-[#0F172A]">{c.name}</p>
                <p className="text-[12px] text-[#64748B]">{c.phone}</p>
              </div>
              <button className="w-8 h-8 flex items-center justify-center text-[#94A3B8]">
                <div className="w-4 h-4"><Icon.Edit /></div>
              </button>
              <button className="w-8 h-8 flex items-center justify-center text-[#DC2626]">
                <div className="w-4 h-4"><Icon.Trash /></div>
              </button>
            </div>
          ))}
        </Card>

        {/* Notifications */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-3">Notifications</h3>
          {[
            { key: "push", label: "Push Notifications", sub: "Instant alerts on this device" },
            { key: "sms", label: "SMS Alerts", sub: "Text to all emergency contacts" },
            { key: "voice", label: "Voice Calls", sub: "Automated call for critical alerts" },
            { key: "quiet", label: "Quiet Hours", sub: "11:00 PM – 7:00 AM", action: () => navigate("quiet-hours") },
          ].map(item => (
            <div key={item.key} className="flex items-center justify-between py-3 border-b border-[#F8FAFC] last:border-0">
              <div className="flex-1">
                <p className="text-[14px] font-medium text-[#0F172A]">{item.label}</p>
                <p className="text-[12px] text-[#64748B]">{item.sub}</p>
              </div>
              {item.action ? (
                <button onClick={item.action} className="flex items-center gap-1 text-[13px] text-[#0F766E] font-medium">
                  Edit <div className="w-3.5 h-3.5"><Icon.ChevronRight /></div>
                </button>
              ) : (
                <Toggle value={notifs[item.key as keyof typeof notifs]} onChange={v => setNotifs(n => ({ ...n, [item.key]: v }))} />
              )}
            </div>
          ))}
        </Card>

        {/* Device Info */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-3">Device Information</h3>
          {[
            { label: "Device ID", value: "SLP-2024-KA-00142" },
            { label: "Battery Level", value: "76%" },
            { label: "Last Heartbeat", value: "12 seconds ago" },
            { label: "Hardware Version", value: "v2.1 Rev C" },
            { label: "Firmware", value: "3.4.1 (latest)" },
            { label: "Signal Strength", value: "−72 dBm (Good)" },
          ].map(item => (
            <div key={item.label} className="flex items-center justify-between py-2.5 border-b border-[#F8FAFC] last:border-0">
              <span className="text-[13px] text-[#64748B]">{item.label}</span>
              <span className="text-[13px] font-medium text-[#0F172A]">{item.value}</span>
            </div>
          ))}
        </Card>

        {/* Danger Actions */}
        <Card className="p-4 space-y-3">
          <button className="w-full py-3.5 bg-[#FEE2E2] rounded-xl flex items-center justify-center gap-2">
            <div className="w-4 h-4 text-[#DC2626]"><Icon.Power /></div>
            <span className="text-[15px] font-semibold text-[#DC2626]">Restore Power / Restart Device</span>
          </button>
          <button onClick={() => navigate("login")} className="w-full py-3.5 border border-[#E2E8F0] rounded-xl flex items-center justify-center gap-2">
            <div className="w-4 h-4 text-[#64748B]"><Icon.LogOut /></div>
            <span className="text-[15px] font-medium text-[#64748B]">Logout</span>
          </button>
        </Card>
      </div>

      <BottomNav active="settings" navigate={navigate} />
    </div>
  );
}

// ─── 9. Add/Edit Emergency Contact ───────────────────────────────────────────
function AddContactScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [name, setName] = useState("Riya Kumar");
  const [phone, setPhone] = useState("+91 98765 43210");
  const [priority, setPriority] = useState(1);

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Emergency Contact" onBack={() => navigate("settings")} />
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        <Card className="p-4 space-y-4">
          <div>
            <label className="text-[13px] font-medium text-[#0F172A] mb-1.5 block">Full Name</label>
            <input
              value={name}
              onChange={e => setName(e.target.value)}
              className="w-full px-4 py-3.5 border border-[#E2E8F0] rounded-xl text-[15px] text-[#0F172A] outline-none focus:border-[#0F766E] focus:ring-2 focus:ring-[#0F766E]/10 bg-white transition-all"
              placeholder="Contact name"
            />
          </div>
          <div>
            <label className="text-[13px] font-medium text-[#0F172A] mb-1.5 block">Phone Number</label>
            <input
              value={phone}
              onChange={e => setPhone(e.target.value)}
              className="w-full px-4 py-3.5 border border-[#E2E8F0] rounded-xl text-[15px] text-[#0F172A] outline-none focus:border-[#0F766E] focus:ring-2 focus:ring-[#0F766E]/10 bg-white transition-all"
              placeholder="+91 XXXXX XXXXX"
            />
          </div>
          <div>
            <label className="text-[13px] font-medium text-[#0F172A] mb-2 block">Alert Priority</label>
            <div className="flex gap-2">
              {[1, 2, 3].map(p => (
                <button
                  key={p}
                  onClick={() => setPriority(p)}
                  className={`flex-1 py-3 rounded-xl border-2 font-semibold text-[15px] transition-all ${priority === p ? "border-[#0F766E] bg-[#CCFBF1] text-[#0F766E]" : "border-[#E2E8F0] text-[#64748B]"}`}
                >
                  #{p}
                </button>
              ))}
            </div>
            <p className="text-[12px] text-[#64748B] mt-1.5">Priority #1 is contacted first during emergencies</p>
          </div>
        </Card>

        <Card className="p-4">
          <h4 className="text-[13px] font-semibold text-[#0F172A] mb-2">Alert Methods</h4>
          {[
            { label: "SMS Alerts", default: true },
            { label: "Voice Calls", default: true },
          ].map(item => (
            <div key={item.label} className="flex items-center justify-between py-2.5 border-b border-[#F8FAFC] last:border-0">
              <span className="text-[14px] text-[#0F172A]">{item.label}</span>
              <Toggle value={item.default} onChange={() => {}} />
            </div>
          ))}
        </Card>
      </div>

      <div className="bg-white border-t border-[#E2E8F0] px-4 py-4">
        <button onClick={() => navigate("settings")} className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[16px]">
          Save Contact
        </button>
      </div>
    </div>
  );
}

// ─── 10. Quiet Hours ──────────────────────────────────────────────────────────
function QuietHoursScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [enabled, setEnabled] = useState(true);
  const [start, setStart] = useState("23:00");
  const [end, setEnd] = useState("07:00");

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Quiet Hours" onBack={() => navigate("settings")} />
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-4">
        {/* Enable toggle */}
        <Card className="p-4">
          <div className="flex items-center justify-between">
            <div>
              <p className="text-[15px] font-semibold text-[#0F172A]">Enable Quiet Hours</p>
              <p className="text-[13px] text-[#64748B]">Suppress non-critical alerts during sleep time</p>
            </div>
            <Toggle value={enabled} onChange={setEnabled} />
          </div>
        </Card>

        <Card className={`p-4 space-y-4 transition-opacity ${enabled ? "opacity-100" : "opacity-40"}`}>
          <div>
            <label className="text-[13px] font-medium text-[#0F172A] mb-1.5 block">Start Time</label>
            <div className="flex items-center border border-[#E2E8F0] rounded-xl bg-white overflow-hidden focus-within:border-[#0F766E]">
              <div className="px-4 py-3.5 border-r border-[#E2E8F0]">
                <div className="w-4 h-4 text-[#64748B]"><Icon.Clock /></div>
              </div>
              <input
                type="time"
                value={start}
                onChange={e => setStart(e.target.value)}
                disabled={!enabled}
                className="flex-1 px-4 py-3.5 text-[15px] text-[#0F172A] outline-none bg-transparent"
              />
            </div>
          </div>
          <div>
            <label className="text-[13px] font-medium text-[#0F172A] mb-1.5 block">End Time</label>
            <div className="flex items-center border border-[#E2E8F0] rounded-xl bg-white overflow-hidden focus-within:border-[#0F766E]">
              <div className="px-4 py-3.5 border-r border-[#E2E8F0]">
                <div className="w-4 h-4 text-[#64748B]"><Icon.Clock /></div>
              </div>
              <input
                type="time"
                value={end}
                onChange={e => setEnd(e.target.value)}
                disabled={!enabled}
                className="flex-1 px-4 py-3.5 text-[15px] text-[#0F172A] outline-none bg-transparent"
              />
            </div>
          </div>

          <div className="bg-[#FEF3C7] rounded-xl p-3 flex gap-2">
            <div className="w-4 h-4 text-[#D97706] flex-shrink-0 mt-0.5"><Icon.AlertTriangle /></div>
            <p className="text-[12px] text-[#92400E]">
              <span className="font-semibold">Important:</span> Critical gas alerts and emergency notifications will always be delivered regardless of quiet hours settings.
            </p>
          </div>
        </Card>

        {/* Preview */}
        {enabled && (
          <Card className="p-4">
            <h4 className="text-[13px] font-semibold text-[#0F172A] mb-2">Schedule Preview</h4>
            <div className="h-8 bg-[#F1F5F9] rounded-lg relative overflow-hidden">
              <div
                className="absolute top-0 h-full bg-[#CCFBF1] rounded-lg"
                style={{ left: "0%", width: `${(parseInt(end)/24)*100}%` }}
              />
              <div
                className="absolute top-0 h-full bg-[#CCFBF1] rounded-lg"
                style={{ left: `${(parseInt(start)/24)*100}%`, right: "0%" }}
              />
              <div className="absolute inset-0 flex items-center justify-center">
                <span className="text-[11px] font-semibold text-[#0F766E]">Quiet: {start} – {end}</span>
              </div>
            </div>
          </Card>
        )}
      </div>

      <div className="bg-white border-t border-[#E2E8F0] px-4 py-4">
        <button onClick={() => navigate("settings")} className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[16px]">
          Save Quiet Hours
        </button>
      </div>
    </div>
  );
}

// ─── 11. Profile ──────────────────────────────────────────────────────────────
function ProfileScreen({ navigate }: { navigate: (s: Screen) => void }) {
  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Profile" onBack={() => navigate("home")} />
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
        {/* User card */}
        <Card className="p-5">
          <div className="flex items-center gap-4">
            <div className="w-16 h-16 rounded-full bg-gradient-to-br from-[#0F766E] to-[#134E4A] flex items-center justify-center text-white text-2xl font-bold flex-shrink-0">
              RK
            </div>
            <div>
              <h2 className="text-[18px] font-bold text-[#0F172A]">Rajesh Kumar</h2>
              <p className="text-[14px] text-[#64748B]">+91 98765 43210</p>
              <div className="flex items-center gap-1.5 mt-1.5">
                <div className="w-2 h-2 rounded-full bg-[#16A34A]" />
                <span className="text-[12px] text-[#16A34A] font-medium">Account Verified</span>
              </div>
            </div>
          </div>
        </Card>

        {/* Device info */}
        <Card className="p-4">
          <h3 className="text-[15px] font-semibold text-[#0F172A] mb-3">Linked Device</h3>
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-[#CCFBF1] flex items-center justify-center">
              <div className="w-5 h-5 text-[#0F766E]"><Icon.ShieldCheck /></div>
            </div>
            <div>
              <p className="text-[14px] font-semibold text-[#0F172A]">SafeLPG Sensor v2.1</p>
              <p className="text-[12px] text-[#64748B]">ID: SLP-2024-KA-00142 · Kitchen</p>
            </div>
            <div className="ml-auto">
              <span className="px-2 py-1 rounded-full text-[11px] font-semibold bg-[#DCFCE7] text-[#16A34A]">Online</span>
            </div>
          </div>
        </Card>

        {/* Menu items */}
        <Card className="divide-y divide-[#F1F5F9]">
          {[
            { icon: Icon.HelpCircle, label: "Help & Support", sub: "FAQs, contact us" },
            { icon: Icon.Lock, label: "Privacy Policy", sub: "Data usage & permissions" },
            { icon: Icon.Info, label: "About SafeLPG", sub: "Version 2.1.0" },
          ].map(({ icon: Ic, label, sub }) => (
            <button key={label} className="w-full flex items-center gap-4 px-4 py-4 text-left active:bg-[#F8FAFC]">
              <div className="w-9 h-9 rounded-xl bg-[#F1F5F9] flex items-center justify-center flex-shrink-0">
                <div className="w-4.5 h-4.5 text-[#64748B]" style={{ width: 18, height: 18 }}><Ic /></div>
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-[14px] font-medium text-[#0F172A]">{label}</p>
                <p className="text-[12px] text-[#64748B]">{sub}</p>
              </div>
              <div className="w-4 h-4 text-[#CBD5E1]"><Icon.ChevronRight /></div>
            </button>
          ))}
        </Card>

        <button onClick={() => navigate("login")} className="w-full py-4 border-2 border-[#DC2626] rounded-xl flex items-center justify-center gap-2">
          <div className="w-4 h-4 text-[#DC2626]"><Icon.LogOut /></div>
          <span className="text-[15px] font-semibold text-[#DC2626]">Logout</span>
        </button>
      </div>
    </div>
  );
}

// ─── 12. Empty States ─────────────────────────────────────────────────────────
function EmptyStatesScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [tab, setTab] = useState(0);
  const states = [
    {
      title: "No Alerts",
      sub: "Alerts",
      message: "Your home is safe and secure.\nNo alerts have been triggered.",
      action: "Check Settings",
      actionFn: () => navigate("settings"),
      color: "#16A34A",
      bg: "#DCFCE7",
    },
    {
      title: "No History",
      sub: "History",
      message: "No events recorded yet.\nYour first activity will appear here.",
      action: "Go to Dashboard",
      actionFn: () => navigate("home"),
      color: "#0F766E",
      bg: "#CCFBF1",
    },
    {
      title: "No Contacts",
      sub: "Contacts",
      message: "No emergency contacts added.\nAdd a contact to receive alerts.",
      action: "Add Contact",
      actionFn: () => navigate("add-contact"),
      color: "#D97706",
      bg: "#FEF3C7",
    },
  ];
  const s = states[tab];

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Empty States" onBack={() => navigate("home")} />
        <div className="flex gap-2 px-5 pb-3">
          {states.map((st, i) => (
            <button key={i} onClick={() => setTab(i)} className={`px-3 py-1.5 rounded-full text-[12px] font-medium transition-colors ${tab === i ? "bg-[#0F766E] text-white" : "bg-[#F1F5F9] text-[#64748B]"}`}>
              {st.sub}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-8 text-center">
        {/* Illustration */}
        <div className="relative mb-8">
          <div className="w-32 h-32 rounded-full flex items-center justify-center" style={{ background: s.bg }}>
            <div className="w-16 h-16" style={{ color: s.color }}>
              {tab === 0 && <Icon.ShieldCheck />}
              {tab === 1 && <Icon.History />}
              {tab === 2 && <Icon.Phone />}
            </div>
          </div>
          <div className="absolute -bottom-1 -right-1 w-8 h-8 rounded-full bg-white shadow-md flex items-center justify-center" style={{ color: s.color }}>
            <div className="w-4 h-4"><Icon.Check /></div>
          </div>
        </div>
        <h2 className="text-[20px] font-bold text-[#0F172A] mb-2">{s.title}</h2>
        <p className="text-[15px] text-[#64748B] leading-relaxed whitespace-pre-line mb-8">{s.message}</p>
        <button onClick={s.actionFn} className="px-8 py-3.5 bg-[#0F766E] rounded-xl text-white font-semibold text-[16px]">
          {s.action}
        </button>
      </div>
    </div>
  );
}

// ─── 13. Loading State ────────────────────────────────────────────────────────
function LoadingScreen({ navigate }: { navigate: (s: Screen) => void }) {
  function Skeleton({ className = "" }: { className?: string }) {
    return <div className={`bg-[#E2E8F0] rounded-lg animate-pulse ${className}`} />;
  }

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <div className="flex items-center justify-between px-5 py-3">
          <Skeleton className="w-24 h-6 rounded-lg" />
          <div className="flex gap-2">
            <Skeleton className="w-8 h-8 rounded-full" />
            <Skeleton className="w-8 h-8 rounded-full" />
          </div>
        </div>
      </div>

      <div className="flex-1 overflow-y-auto px-4 py-4 space-y-3">
        {/* Gas card skeleton */}
        <div className="bg-white rounded-2xl shadow-[0_1px_8px_0_rgba(15,23,42,0.06)] p-5">
          <div className="flex justify-between mb-4">
            <Skeleton className="w-32 h-4" />
            <Skeleton className="w-16 h-6 rounded-full" />
          </div>
          <div className="flex justify-center my-4">
            <Skeleton className="w-44 h-24 rounded-xl" />
          </div>
          <div className="grid grid-cols-4 gap-2">
            {[0,1,2,3].map(i => <Skeleton key={i} className="h-12 rounded-xl" />)}
          </div>
        </div>

        {/* System state skeleton */}
        <div className="bg-white rounded-2xl shadow-[0_1px_8px_0_rgba(15,23,42,0.06)] p-4">
          <div className="flex items-center gap-3">
            <Skeleton className="w-10 h-10 rounded-xl flex-shrink-0" />
            <div className="flex-1 space-y-2">
              <Skeleton className="w-24 h-3" />
              <Skeleton className="w-32 h-5" />
            </div>
          </div>
          <Skeleton className="w-full h-1.5 mt-3 rounded-full" />
        </div>

        {/* Quick actions skeleton */}
        <div className="grid grid-cols-3 gap-3">
          {[0,1,2].map(i => <Skeleton key={i} className="h-24 rounded-2xl" />)}
        </div>

        {/* Alert list skeleton */}
        <div className="bg-white rounded-2xl shadow-[0_1px_8px_0_rgba(15,23,42,0.06)] p-4 space-y-3">
          {[0,1,2].map(i => (
            <div key={i} className="flex gap-3">
              <Skeleton className="w-2 h-16 rounded-full flex-shrink-0" />
              <div className="flex-1 space-y-2">
                <Skeleton className="w-3/4 h-4" />
                <Skeleton className="w-full h-3" />
                <Skeleton className="w-1/2 h-3" />
              </div>
            </div>
          ))}
        </div>
      </div>

      <div className="bg-white border-t border-[#E2E8F0]">
        <div className="flex">
          {[0,1,2,3].map(i => (
            <div key={i} className="flex-1 flex flex-col items-center py-2 gap-1.5">
              <Skeleton className="w-6 h-6 rounded-md" />
              <Skeleton className="w-8 h-2 rounded" />
            </div>
          ))}
        </div>
      </div>
    </div>
  );
}

// ─── 14. Error / Offline State ────────────────────────────────────────────────
function ErrorScreen({ navigate }: { navigate: (s: Screen) => void }) {
  const [tab, setTab] = useState<"offline" | "device">("offline");

  return (
    <div className="flex flex-col h-full bg-[#F8FAFC]">
      <div className="bg-white border-b border-[#E2E8F0]">
        <StatusBar />
        <AppBar title="Connection Error" onBack={() => navigate("home")} />
        <div className="flex gap-2 px-5 pb-3">
          {(["offline", "device"] as const).map(t => (
            <button key={t} onClick={() => setTab(t)} className={`px-4 py-1.5 rounded-full text-[12px] font-medium transition-colors ${tab === t ? "bg-[#DC2626] text-white" : "bg-[#F1F5F9] text-[#64748B]"}`}>
              {t === "offline" ? "No Internet" : "Device Offline"}
            </button>
          ))}
        </div>
      </div>

      <div className="flex-1 flex flex-col items-center justify-center px-8 text-center">
        {tab === "offline" ? (
          <>
            <div className="w-28 h-28 rounded-full bg-[#FEE2E2] flex items-center justify-center mb-6">
              <div className="w-14 h-14 text-[#DC2626]"><Icon.WifiOff /></div>
            </div>
            <h2 className="text-[22px] font-bold text-[#0F172A] mb-2">No Internet Connection</h2>
            <p className="text-[15px] text-[#64748B] leading-relaxed mb-2">
              SafeLPG requires an active internet connection to monitor your device and send alerts.
            </p>
            <p className="text-[13px] text-[#94A3B8] mb-8">
              Your device continues to monitor locally and will sync when connected.
            </p>
            <button className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[16px] flex items-center justify-center gap-2">
              <div className="w-4 h-4"><Icon.RefreshCw /></div>
              Retry Connection
            </button>
            <button onClick={() => navigate("home")} className="mt-3 py-3 text-[15px] text-[#64748B] font-medium">
              View Cached Data
            </button>
          </>
        ) : (
          <>
            <div className="w-28 h-28 rounded-full bg-[#FEF3C7] flex items-center justify-center mb-6">
              <div className="w-14 h-14 text-[#D97706]"><Icon.Zap /></div>
            </div>
            <h2 className="text-[22px] font-bold text-[#0F172A] mb-2">Unable to Reach Device</h2>
            <p className="text-[15px] text-[#64748B] leading-relaxed mb-2">
              The SafeLPG sensor (SLP-2024-KA-00142) is not responding. It may be offline or out of range.
            </p>
            <p className="text-[13px] text-[#94A3B8] mb-8">Last seen: 4 minutes ago</p>
            <div className="w-full bg-[#FEF3C7] rounded-xl p-4 mb-6 text-left">
              <p className="text-[13px] font-semibold text-[#92400E] mb-1">Possible causes:</p>
              <ul className="text-[12px] text-[#92400E] space-y-0.5 list-disc list-inside">
                <li>Device power disconnected</li>
                <li>Wi-Fi signal lost at device location</li>
                <li>Hardware fault — check LED status</li>
              </ul>
            </div>
            <button className="w-full py-4 bg-[#0F766E] rounded-xl text-white font-semibold text-[16px] flex items-center justify-center gap-2">
              <div className="w-4 h-4"><Icon.RefreshCw /></div>
              Retry
            </button>
            <button className="mt-3 py-3 text-[15px] text-[#DC2626] font-semibold">
              Report Device Issue
            </button>
          </>
        )}
      </div>
    </div>
  );
}

// ─── Screen config ───────────────────────────────────────────────────────────
const SCREENS: { id: Screen; label: string; group: string }[] = [
  { id: "splash",        label: "Splash",        group: "Onboarding" },
  { id: "login",         label: "Login",         group: "Onboarding" },
  { id: "otp",           label: "OTP Verify",    group: "Onboarding" },
  { id: "home",          label: "Dashboard",     group: "Main" },
  { id: "alerts",        label: "Alert Centre",  group: "Main" },
  { id: "alert-detail",  label: "Alert Detail",  group: "Main" },
  { id: "history",       label: "History",       group: "Main" },
  { id: "settings",      label: "Settings",      group: "Main" },
  { id: "add-contact",   label: "Add Contact",   group: "Flows" },
  { id: "quiet-hours",   label: "Quiet Hours",   group: "Flows" },
  { id: "profile",       label: "Profile",       group: "Flows" },
  { id: "empty-states",  label: "Empty States",  group: "States" },
  { id: "loading",       label: "Loading",       group: "States" },
  { id: "error",         label: "Error/Offline", group: "States" },
];

// ─── Phone Frame ─────────────────────────────────────────────────────────────
function PhoneFrame({ children, label, number, active, onClick }: {
  children: ReactNode; label: string; number: number; active: boolean; onClick: () => void;
}) {
  return (
    <div className="flex flex-col items-center flex-shrink-0 cursor-pointer group" onClick={onClick}>
      {/* Label */}
      <div className="mb-2 text-center">
        <span className={`text-[10px] font-bold uppercase tracking-widest ${active ? "text-[#0F766E]" : "text-[#64748B]"}`}>
          {number < 10 ? `0${number}` : number}
        </span>
        <p className={`text-[12px] font-semibold leading-tight ${active ? "text-white" : "text-[#94A3B8]"}`}>{label}</p>
      </div>

      {/* Frame */}
      <div
        className="relative overflow-hidden flex flex-col transition-all duration-200"
        style={{
          width: 260,
          height: 563,
          borderRadius: 30,
          boxShadow: active
            ? "0 0 0 8px #0F766E44, 0 0 0 9px #0F766E66, 0 20px 60px 0 rgba(0,0,0,0.6)"
            : "0 0 0 8px #1e293b, 0 0 0 9px #334155, 0 12px 32px 0 rgba(0,0,0,0.4)",
        }}
      >
        {/* Notch */}
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-16 h-5 bg-[#0F172A] rounded-b-xl z-50 flex items-center justify-center gap-1">
          <div className="w-1.5 h-1.5 rounded-full bg-[#1e293b]" />
          <div className="w-6 h-0.5 rounded-full bg-[#1e293b]" />
        </div>

        {/* Scaled screen content */}
        <div
          className="absolute origin-top-left"
          style={{ width: 390, height: 844, transform: "scale(0.6667)", left: 0, top: 0 }}
        >
          <div className="w-full h-full bg-white overflow-hidden flex flex-col pointer-events-none">
            {children}
          </div>
        </div>

        {/* Home bar */}
        <div className="absolute bottom-1.5 left-1/2 -translate-x-1/2 w-16 h-0.5 bg-[#0F172A]/20 rounded-full z-50" />
      </div>
    </div>
  );
}

// ─── App Root ─────────────────────────────────────────────────────────────────
export default function App() {
  const [current, setCurrent] = useState<Screen>("home");
  const [activeGroup, setActiveGroup] = useState<string | null>(null);
  const navigate = (s: Screen) => setCurrent(s);

  const groups = [...new Set(SCREENS.map(s => s.group))];

  const makeScreenNode = (id: Screen): ReactNode => {
    const nav = navigate;
    switch (id) {
      case "splash":       return <SplashScreen navigate={nav} />;
      case "login":        return <LoginScreen navigate={nav} />;
      case "otp":          return <OTPScreen navigate={nav} />;
      case "home":         return <HomeScreen navigate={nav} />;
      case "alerts":       return <AlertsScreen navigate={nav} />;
      case "alert-detail": return <AlertDetailScreen navigate={nav} />;
      case "history":      return <HistoryScreen navigate={nav} />;
      case "settings":     return <SettingsScreen navigate={nav} />;
      case "add-contact":  return <AddContactScreen navigate={nav} />;
      case "quiet-hours":  return <QuietHoursScreen navigate={nav} />;
      case "profile":      return <ProfileScreen navigate={nav} />;
      case "empty-states": return <EmptyStatesScreen navigate={nav} />;
      case "loading":      return <LoadingScreen navigate={nav} />;
      case "error":        return <ErrorScreen navigate={nav} />;
    }
  };

  const filtered = activeGroup
    ? SCREENS.filter(s => s.group === activeGroup)
    : SCREENS;

  return (
    <div className="min-h-screen bg-[#0A0F1E] flex flex-col">
      {/* Top bar */}
      <div className="flex items-center justify-between px-8 py-5 border-b border-[#1e293b] flex-shrink-0">
        <div className="flex items-center gap-3">
          <div className="w-8 h-8 text-[#0F766E]"><Icon.ShieldCheck /></div>
          <div>
            <h1 className="text-white font-bold text-[16px] tracking-tight">SafeLPG</h1>
            <p className="text-[#64748B] text-[11px]">End-User UI Kit · 14 Screens</p>
          </div>
        </div>
        <div className="flex items-center gap-2">
          {/* Group filters */}
          <button
            onClick={() => setActiveGroup(null)}
            className={`px-3 py-1.5 rounded-full text-[11px] font-semibold transition-all ${!activeGroup ? "bg-[#0F766E] text-white" : "bg-[#1e293b] text-[#64748B]"}`}
          >
            All
          </button>
          {groups.map(g => (
            <button
              key={g}
              onClick={() => setActiveGroup(activeGroup === g ? null : g)}
              className={`px-3 py-1.5 rounded-full text-[11px] font-semibold transition-all ${activeGroup === g ? "bg-[#0F766E] text-white" : "bg-[#1e293b] text-[#64748B]"}`}
            >
              {g}
            </button>
          ))}
        </div>
      </div>

      {/* Gallery */}
      <div className="flex-1 overflow-x-auto overflow-y-hidden">
        <div className="flex gap-6 px-8 py-8 items-start h-full" style={{ width: "max-content" }}>
          {filtered.map((s, i) => (
            <PhoneFrame
              key={s.id}
              label={s.label}
              number={SCREENS.findIndex(x => x.id === s.id) + 1}
              active={current === s.id}
              onClick={() => setCurrent(s.id)}
            >
              {makeScreenNode(s.id)}
            </PhoneFrame>
          ))}
        </div>
      </div>

      {/* Active screen detail panel */}
      <div className="flex-shrink-0 border-t border-[#1e293b] bg-[#0d1424] px-8 py-3 flex items-center gap-6">
        <div className="flex items-center gap-2">
          <div className="w-2 h-2 rounded-full bg-[#0F766E]" />
          <span className="text-[12px] font-semibold text-white">
            {SCREENS.find(s => s.id === current)?.label}
          </span>
          <span className="text-[11px] text-[#64748B]">·</span>
          <span className="text-[11px] text-[#64748B]">{SCREENS.find(s => s.id === current)?.group}</span>
        </div>
        <div className="h-3 w-px bg-[#1e293b]" />
        <span className="text-[11px] text-[#64748B]">Click any screen to select · Scroll horizontally to browse all 14 screens</span>
        <div className="ml-auto flex gap-1.5">
          {SCREENS.map(s => (
            <button
              key={s.id}
              onClick={() => setCurrent(s.id)}
              title={s.label}
              className={`w-2 h-2 rounded-full transition-all ${current === s.id ? "bg-[#0F766E] scale-125" : "bg-[#334155]"}`}
            />
          ))}
        </div>
      </div>
    </div>
  );
}
