import tkinter as tk
from tkinter import ttk, messagebox
import time
import threading
import os
import sys
from datetime import datetime
import platform

class FourSessionPomodoro:
    def __init__(self, root):
        self.root = root
        self.root.title("🍅 4-Session Pomodoro Timer")
        self.root.geometry("1920x1080")
        self.root.resizable(False, False)
        self.root.configure(bg='#1A1A2E')

        # Colors
        self.colors = {
            'bg': '#1A1A2E',
            'card_bg': '#16213E',
            'accent': '#0F3460',
            'focus': '#E94560',      # Red for focus
            'break_color': '#00B894', # Green for break
            'revise': '#0984E3',     # Blue for revise
            'ready': '#FDCB6E',      # Yellow for ready
            'text_light': '#FFFFFF',
            'text_muted': '#B2B2B2',
            'gradient1': '#0F3460',
            'gradient2': '#16213E'
        }

        # 4 Sessions with names and times (in minutes)
        self.sessions = [
            ("FOCUS", 25, self.colors['focus'], "Deep work session - No distractions!"),
            ("BREAK", 10, self.colors['break_color'], "Relax and recharge your mind"),
            ("REVISE", 10, self.colors['revise'], "Review what you've learned"),
            ("READY", 5, self.colors['ready'], "Get ready for next focus session")
        ]

        self.current_session = 0
        self.current_time = self.sessions[0][1] * 60  # Convert to seconds
        self.is_running = False
        self.cycle_count = 0
        self.session_history = []
        self.bell_playing = False  # Flag to control bell sound loop

        # Configure styles
        self.configure_styles()
        self.setup_ui()
        self.update_display()

    def configure_styles(self):
        """Configure modern ttk styles"""
        style = ttk.Style()
        style.theme_use('clam')

        # Modern button style
        style.configure('Modern.TButton',
                       font=('Arial', 11, 'bold'),
                       borderwidth=0,
                       focuscolor='none',
                       padding=(20, 12),
                       relief='flat')

        style.map('Modern.TButton',
                 background=[('active', self.colors['accent']),
                           ('pressed', self.colors['accent'])],
                 foreground=[('active', 'white')])

    def create_gradient_frame(self, parent, color1, color2, width, height):
        """Create a gradient background frame"""
        canvas = tk.Canvas(parent, width=width, height=height, highlightthickness=0)
        canvas.pack(fill='both', expand=True)

        # Create gradient
        for i in range(height):
            ratio = i / height
            r = int(int(color1[1:3], 16) * (1 - ratio) + int(color2[1:3], 16) * ratio)
            g = int(int(color1[3:5], 16) * (1 - ratio) + int(color2[3:5], 16) * ratio)
            b = int(int(color1[5:7], 16) * (1 - ratio) + int(color2[5:7], 16) * ratio)
            color = f"#{r:02x}{g:02x}{b:02x}"
            canvas.create_line(0, i, width, i, fill=color)

        return canvas

    def play_alarm(self):
        """Play alarm sound using system beeps"""
        def play_sound():
            try:
                # Play multiple beeps
                for i in range(5):
                    # System beep
                    print('\a', end='', flush=True)
                    # Flash window (if possible)
                    self.root.bell()
                    # Wait between beeps
                    time.sleep(0.3)
            except Exception as e:
                print(f"Sound error: {e}")

        # Play in separate thread to avoid blocking GUI
        sound_thread = threading.Thread(target=play_sound)
        sound_thread.daemon = True
        sound_thread.start()

    def play_bell_sound(self):
        """Play a bell sound when session finishes - loops until stopped"""
        def play_bell():
            self.bell_playing = True
            try:
                system_platform = platform.system()
                while self.bell_playing:
                    if system_platform == "Windows":
                        import winsound
                        winsound.Beep(1000, 1000)
                        time.sleep(0.5)
                    elif system_platform == "Darwin":  # macOS
                        os.system('afplay /System/Library/Sounds/Glass.aiff &')
                        time.sleep(0.5)
                    else:  # Linux and other Unix-like systems
                        os.system('echo -e "\a"')
                        time.sleep(0.5)
            except Exception as e:
                print(f"Bell sound error: {e}")
                self.play_alarm()

        bell_thread = threading.Thread(target=play_bell)
        bell_thread.daemon = True
        bell_thread.start()

    def stop_bell_sound(self):
        """Stop the looping bell sound"""
        self.bell_playing = False

    def setup_ui(self):
        # Main container with gradient
        main_container = tk.Frame(self.root, bg=self.colors['bg'])
        main_container.pack(fill='both', expand=True, padx=30, pady=30)

        # Header with modern design
        header_frame = tk.Frame(main_container, bg=self.colors['bg'])
        header_frame.pack(fill='x', pady=(0, 30))

        # Animated logo and title container
        logo_title_frame = tk.Frame(header_frame, bg=self.colors['bg'])
        logo_title_frame.pack(anchor='center')

        self.logo_label = tk.Label(logo_title_frame, text="🍅",
                                  font=("Arial", 64, "bold"),
                                  bg=self.colors['bg'], fg=self.colors['focus'])
        self.logo_label.pack(side='left', padx=(0, 15))

        title_container = tk.Frame(logo_title_frame, bg=self.colors['bg'])
        title_container.pack(side='left')

        title_label = tk.Label(title_container, text="POMODORO PRO",
                              font=("Arial", 28, "bold"),
                              bg=self.colors['bg'], fg=self.colors['text_light'])
        title_label.pack(anchor='w')

        subtitle_label = tk.Label(title_container, text="4-Session Focus Timer",
                                 font=("Arial", 14),
                                 bg=self.colors['bg'], fg=self.colors['text_muted'])
        subtitle_label.pack(anchor='w')

        # Session Progress with modern cards
        session_progress_frame = tk.Frame(main_container, bg=self.colors['bg'])
        session_progress_frame.pack(fill='x', pady=(0, 30))

        progress_title = tk.Label(session_progress_frame, text="SESSION PROGRESS",
                                 font=("Arial", 12, "bold"),
                                 bg=self.colors['bg'], fg=self.colors['text_muted'])
        progress_title.pack(anchor='w')

        # Session indicators - modern cards
        self.session_indicators_frame = tk.Frame(session_progress_frame, bg=self.colors['bg'])
        self.session_indicators_frame.pack(fill='x', pady=15)

        self.session_frames = []
        for i, (name, minutes, color, desc) in enumerate(self.sessions):
            # Create modern card frame
            session_frame = tk.Frame(self.session_indicators_frame,
                                   bg=self.colors['card_bg'],
                                   relief='flat',
                                   bd=0)
            session_frame.pack(side='left', padx=8, fill='both', expand=True)
            session_frame.pack_propagate(False)

            # Add subtle border effect
            border_frame = tk.Frame(session_frame, bg=color, height=4)
            border_frame.pack(fill='x')

            content_frame = tk.Frame(session_frame, bg=self.colors['card_bg'], padx=15, pady=15)
            content_frame.pack(fill='both', expand=True)

            # Status indicator with animation
            status_canvas = tk.Canvas(content_frame, width=30, height=30,
                                     bg=self.colors['card_bg'], highlightthickness=0)
            status_canvas.pack(anchor='nw')
            status_indicator = status_canvas.create_oval(5, 5, 25, 25,
                                                        fill=self.colors['text_muted'], outline="")

            # Session name with icon
            icon_frame = tk.Frame(content_frame, bg=self.colors['card_bg'])
            icon_frame.pack(fill='x', pady=(5, 8))

            icons = {"FOCUS": "🎯", "BREAK": "☕", "REVISE": "📚", "READY": "⚡"}
            icon_label = tk.Label(icon_frame, text=icons.get(name, "⏱️"),
                                 font=("Arial", 14),
                                 bg=self.colors['card_bg'], fg=color)
            icon_label.pack(side='left')

            name_label = tk.Label(icon_frame, text=name,
                                 font=("Arial", 11, "bold"),
                                 bg=self.colors['card_bg'], fg=self.colors['text_light'])
            name_label.pack(side='left', padx=(8, 0))

            # Session time
            time_label = tk.Label(content_frame, text=f"{minutes} min",
                                 font=("Arial", 16, "bold"),
                                 bg=self.colors['card_bg'], fg=self.colors['text_light'])
            time_label.pack(pady=(0, 5))

            # Session description
            desc_label = tk.Label(content_frame, text=desc,
                                font=("Arial", 9),
                                bg=self.colors['card_bg'], fg=self.colors['text_muted'],
                                wraplength=120, justify='center')
            desc_label.pack()

            self.session_frames.append({
                'frame': session_frame,
                'border_frame': border_frame,
                'status_canvas': status_canvas,
                'status_indicator': status_indicator,
                'name_label': name_label,
                'time_label': time_label,
                'desc_label': desc_label,
                'color': color
            })

        # Main Timer Card - Enhanced design
        self.timer_card = tk.Frame(main_container, bg=self.colors['card_bg'],
                                  relief='flat', bd=0)
        self.timer_card.pack(fill='x', pady=20)

        # Add glowing border effect
        self.timer_border = tk.Frame(self.timer_card, bg=self.colors['focus'], height=2)
        self.timer_border.pack(fill='x')

        timer_content = tk.Frame(self.timer_card, bg=self.colors['card_bg'], padx=40, pady=40)
        timer_content.pack(fill='both', expand=True)

        # Current session info
        session_info_frame = tk.Frame(timer_content, bg=self.colors['card_bg'])
        session_info_frame.pack(fill='x', pady=(0, 20))

        self.current_session_label = tk.Label(session_info_frame,
                                             text="FOCUS SESSION",
                                             font=("Arial", 24, "bold"),
                                             bg=self.colors['card_bg'],
                                             fg=self.colors['text_light'])
        self.current_session_label.pack()

        self.session_desc_label = tk.Label(session_info_frame,
                                          text="Deep work session - No distractions!",
                                          font=("Arial", 12),
                                          bg=self.colors['card_bg'],
                                          fg=self.colors['text_muted'])
        self.session_desc_label.pack(pady=(8, 0))

        # Timer display with circular progress effect
        timer_display_container = tk.Frame(timer_content, bg=self.colors['card_bg'])
        timer_display_container.pack(pady=30)

        # Time display
        self.time_label = tk.Label(timer_display_container,
                                  text="25:00",
                                  font=("Arial", 72, "bold"),
                                  bg=self.colors['card_bg'],
                                  fg=self.colors['text_light'])
        self.time_label.pack()

        # Progress text
        self.progress_label = tk.Label(timer_display_container,
                                      text="0% Complete",
                                      font=("Arial", 14),
                                      bg=self.colors['card_bg'],
                                      fg=self.colors['text_muted'])
        self.progress_label.pack(pady=(10, 0))

        # Control Buttons - Modern layout
        controls_frame = tk.Frame(main_container, bg=self.colors['bg'])
        controls_frame.pack(fill='x', pady=30)

        # Main control buttons
        main_controls_frame = tk.Frame(controls_frame, bg=self.colors['bg'])
        main_controls_frame.pack(pady=10)

        button_configs = [
            ("🎯 START", self.start_timer, 'focus'),
            ("⏹ STOP", self.stop_timer, 'focus'),
            ("⏸ PAUSE", self.pause_timer, 'focus'),
            ("🔄 RESET", self.reset_timer, 'break_color'),
            ("⏭ SKIP", self.skip_session, 'revise')
        ]

        self.control_buttons = {}
        for text, command, color_type in button_configs:
            btn = ttk.Button(main_controls_frame,
                           text=text,
                           command=command,
                           style='Modern.TButton')
            btn.pack(side='left', padx=6)
            self.control_buttons[text] = btn

        # Initially disable some buttons
        self.control_buttons["⏹ STOP"].config(state='disabled')
        self.control_buttons["⏸ PAUSE"].config(state='disabled')

        # Stats section
        stats_frame = tk.Frame(main_container, bg=self.colors['bg'])
        stats_frame.pack(fill='x', pady=20)

        # Cycle counter
        cycle_card = tk.Frame(stats_frame, bg=self.colors['card_bg'], padx=20, pady=15)
        cycle_card.pack(side='left', padx=(0, 15))

        cycle_icon = tk.Label(cycle_card, text="🔄", font=("Arial", 16),
                             bg=self.colors['card_bg'], fg=self.colors['ready'])
        cycle_icon.pack()

        cycle_text = tk.Label(cycle_card, text="Current Cycle",
                            font=("Arial", 10),
                            bg=self.colors['card_bg'], fg=self.colors['text_muted'])
        cycle_text.pack()

        self.cycle_label = tk.Label(cycle_card, text="1",
                                   font=("Arial", 18, "bold"),
                                   bg=self.colors['card_bg'], fg=self.colors['text_light'])
        self.cycle_label.pack()

        # Session History - Modern card
        history_card = tk.Frame(stats_frame, bg=self.colors['card_bg'])
        history_card.pack(side='left', fill='x', expand=True, padx=(15, 0))

        history_header = tk.Frame(history_card, bg=self.colors['card_bg'], padx=20, pady=15)
        history_header.pack(fill='x')

        history_icon = tk.Label(history_header, text="📋", font=("Arial", 14),
                               bg=self.colors['card_bg'], fg=self.colors['text_light'])
        history_icon.pack(side='left')

        history_title = tk.Label(history_header, text="SESSION HISTORY",
                                font=("Arial", 11, "bold"),
                                bg=self.colors['card_bg'], fg=self.colors['text_light'])
        history_title.pack(side='left', padx=(8, 0))

        self.history_text = tk.Text(history_card, height=4, font=("Arial", 10),
                                   bg=self.colors['card_bg'], fg=self.colors['text_light'],
                                   relief='flat', bd=0, padx=20, pady=10)
        self.history_text.pack(fill='both', expand=True)
        self.history_text.config(state='disabled')

    def update_session_indicators(self):
        """Update the session progress indicators with animations"""
        for i, session_data in enumerate(self.session_frames):
            if i == self.current_session:
                # Current session - highlight with animation
                session_data['border_frame'].config(bg=session_data['color'])
                session_data['status_canvas'].itemconfig(session_data['status_indicator'],
                                                       fill=session_data['color'])
                session_data['frame'].config(bg=self.colors['card_bg'])
            elif i < self.current_session:
                # Completed session
                session_data['border_frame'].config(bg=session_data['color'])
                session_data['status_canvas'].itemconfig(session_data['status_indicator'],
                                                       fill=session_data['color'])
                session_data['frame'].config(bg=self.colors['card_bg'])
            else:
                # Upcoming session
                session_data['border_frame'].config(bg=self.colors['accent'])
                session_data['status_canvas'].itemconfig(session_data['status_indicator'],
                                                       fill=self.colors['text_muted'])
                session_data['frame'].config(bg=self.colors['card_bg'])

    def update_display(self):
        """Update all display elements"""
        session_name, duration, color, desc = self.sessions[self.current_session]
        total_seconds = duration * 60
        progress = 1 - (self.current_time / total_seconds) if total_seconds > 0 else 0

        # Update main display
        self.time_label.config(text=self.format_time(self.current_time))
        self.current_session_label.config(text=f"{session_name} SESSION", fg=color)
        self.session_desc_label.config(text=desc)
        self.progress_label.config(text=f"{int(progress * 100)}% Complete")

        # Update logo color
        self.logo_label.config(fg=color)

        # Update timer border color
        self.timer_border.config(bg=color)

        # Update session indicators
        self.update_session_indicators()

        # Update cycle counter
        self.cycle_label.config(text=f"{self.cycle_count + 1}")

    def format_time(self, seconds):
        """Format seconds into MM:SS"""
        minutes = seconds // 60
        seconds = seconds % 60
        return f"{minutes:02d}:{seconds:02d}"

    def start_timer(self):
        """Start the timer"""
        if not self.is_running:
            self.is_running = True
            self.control_buttons["🎯 START"].config(state='disabled')
            self.control_buttons["⏹ STOP"].config(state='normal')
            self.control_buttons["⏸ PAUSE"].config(state='normal')
            self.run_timer()
            self.add_to_history("STARTED")

    def stop_timer(self):
        """Stop the timer completely"""
        self.is_running = False
        self.control_buttons["🎯 START"].config(state='normal')
        self.control_buttons["⏹ STOP"].config(state='disabled')
        self.control_buttons["⏸ PAUSE"].config(state='disabled')
        self.add_to_history("STOPPED")

    def pause_timer(self):
        """Pause the timer"""
        if self.is_running:
            self.is_running = False
            self.control_buttons["⏸ PAUSE"].config(text="▶ RESUME")
            self.add_to_history("PAUSED")
        else:
            self.is_running = True
            self.control_buttons["⏸ PAUSE"].config(text="⏸ PAUSE")
            self.run_timer()
            self.add_to_history("RESUMED")

    def reset_timer(self):
        """Reset timer to first session"""
        self.is_running = False
        self.current_session = 0
        self.current_time = self.sessions[0][1] * 60
        self.control_buttons["🎯 START"].config(state='normal')
        self.control_buttons["⏹ STOP"].config(state='disabled')
        self.control_buttons["⏸ PAUSE"].config(text="⏸ PAUSE", state='disabled')
        self.update_display()
        self.add_to_history("RESET")

    def skip_session(self):
        """Skip to the next session"""
        self.is_running = False
        session_name = self.sessions[self.current_session][0]
        self.add_to_history(f"SKIPPED {session_name}")

        self.current_session = (self.current_session + 1) % len(self.sessions)
        if self.current_session == 0:
            self.cycle_count += 1

        self.current_time = self.sessions[self.current_session][1] * 60
        self.update_display()
        self.control_buttons["🎯 START"].config(state='normal')
        self.control_buttons["⏹ STOP"].config(state='disabled')
        self.control_buttons["⏸ PAUSE"].config(state='disabled')

    def add_to_history(self, action):
        """Add action to history log"""
        session_name = self.sessions[self.current_session][0]
        time_str = datetime.now().strftime('%H:%M:%S')
        history_entry = f"{time_str} - {session_name} - {action}\n"

        self.history_text.config(state='normal')
        self.history_text.insert('end', history_entry)
        self.history_text.see('end')
        self.history_text.config(state='disabled')

        # Keep only last 8 entries
        lines = self.history_text.get('1.0', 'end').split('\n')
        if len(lines) > 9:
            self.history_text.config(state='normal')
            self.history_text.delete('1.0', 'end')
            self.history_text.insert('1.0', '\n'.join(lines[-9:-1]))
            self.history_text.config(state='disabled')

    def run_timer(self):
        """Main timer loop"""
        if self.is_running and self.current_time > 0:
            self.current_time -= 1
            self.update_display()
            self.root.after(1000, self.run_timer)
        elif self.current_time == 0:
            self.session_complete()

    def session_complete(self):
        """Handle session completion"""
        self.is_running = False
        session_name, duration, color, desc = self.sessions[self.current_session]

        # Play bell sound (will loop until stopped)
        self.play_bell_sound()
        self.play_alarm()

        # Add to history
        self.add_to_history("COMPLETED")

        # Show completion message - this will block until OK is clicked
        self.show_completion_message(session_name, duration, desc)

        # Stop the bell sound after user clicks OK
        self.stop_bell_sound()

        # Auto-advance to next session
        self.skip_session()

    def show_completion_message(self, session_name, duration, desc):
        """Show session completion message"""
        icons = {"FOCUS": "🎯", "BREAK": "☕", "REVISE": "📚", "READY": "⚡"}
        icon = icons.get(session_name, "✅")

        messagebox.showinfo(
            f"Session Complete! {icon}",
            f"{session_name} session finished!\n\n"
            f"⏱️ Duration: {duration} minutes\n"
            f"💡 {desc}\n\n"
            "Click OK to continue to next session..."
        )

# Run the application
if __name__ == "__main__":
    root = tk.Tk()
    app = FourSessionPomodoro(root)
    root.mainloop()
