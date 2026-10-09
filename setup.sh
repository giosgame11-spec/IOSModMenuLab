#!/bin/bash
set -euo pipefail

echo "=== IOSModMenuLab setup ==="

mkdir -p Sources

cat > Sources/IOSModMenuLabApp.swift <<'SWIFT'
import SwiftUI

@main
struct IOSModMenuLabApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
SWIFT

cat > Sources/ContentView.swift <<'SWIFT'
import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    @State private var showFloatingMenu = true

    var body: some View {
        ZStack {
            Color(red: 0.055, green: 0.075, blue: 0.12)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "slider.horizontal.3")
                        .font(.title2.bold())
                    Text("Mod Menu Lab")
                        .font(.title2.bold())
                    Spacer()
                    Text("DEMO")
                        .font(.caption.bold())
                        .padding(8)
                        .background(.green.opacity(0.2))
                        .clipShape(Capsule())
                }
                .foregroundStyle(.white)
                .padding()

                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(0)

                    PlayerView()
                        .tabItem {
                            Label("Player", systemImage: "person.fill")
                        }
                        .tag(1)

                    VisualView()
                        .tabItem {
                            Label("Visual", systemImage: "eye.fill")
                        }
                        .tag(2)

                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape.fill")
                        }
                        .tag(3)
                }
                .tint(.cyan)
            }

            if showFloatingMenu {
                FloatingMenu {
                    showFloatingMenu = false
                }
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showFloatingMenu = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                                .padding(18)
                                .background(.purple)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                Image(systemName: "app.badge.checkmark")
                    .font(.system(size: 60))
                    .foregroundStyle(.cyan)

                Text("IOSModMenuLab")
                    .font(.largeTitle.bold())

                Text("Môi trường mô phỏng giao diện")
                    .foregroundStyle(.secondary)

                InfoCard(title: "Trạng thái", detail: "Đang chạy giao diện demo",
                         icon: "checkmark.circle.fill")

                InfoCard(title: "Chế độ", detail: "Không kết nối trò chơi",
                         icon: "shield.fill")

                Text("Các nút chỉ thay đổi trạng thái hiển thị trong ứng dụng.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

struct PlayerView: View {
    @State private var speed = 1.0
    @State private var showStats = false

    var body: some View {
        Form {
            Section("Player — mô phỏng") {
                HStack {
                    Text("Tốc độ demo")
                    Spacer()
                    Text(String(format: "%.1fx", speed))
                        .monospacedDigit()
                }
                Slider(value: $speed, in: 0.5...2.0)

                Toggle("Hiện thông số giả lập", isOn: $showStats)

                if showStats {
                    LabeledContent("FPS mẫu", value: "60")
                    LabeledContent("Ping mẫu", value: "32 ms")
                }
            }

            Section {
                Text("Các giá trị này chỉ là dữ liệu minh họa.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct VisualView: View {
    @State private var showLabels = true
    @State private var highlight = false

    var body: some View {
        Form {
            Section("Visual — mô phỏng") {
                Toggle("Hiện nhãn minh họa", isOn: $showLabels)
                Toggle("Tô sáng minh họa", isOn: $highlight)

                if showLabels {
                    HStack {
                        Image(systemName: "person.crop.rectangle")
                        Text("Đối tượng demo")
                        Spacer()
                        if highlight {
                            Text("HIGHLIGHT")
                                .font(.caption.bold())
                                .foregroundStyle(.yellow)
                        }
                    }
                    .padding()
                    .background(highlight ? .orange.opacity(0.2) : .blue.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }

            Section {
                Text("Không đọc dữ liệu hoặc can thiệp trò chơi.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct SettingsView: View {
    @State private var haptics = true
    @State private var compact = false

    var body: some View {
        Form {
            Section("Giao diện") {
                Toggle("Rung phản hồi (demo)", isOn: $haptics)
                Toggle("Chế độ gọn", isOn: $compact)
            }

            Section("Thông tin") {
                LabeledContent("Tên ứng dụng", value: "IOSModMenuLab")
                LabeledContent("Phiên bản", value: "1.0")
                LabeledContent("Mục đích", value: "UI Demo")
            }
        }
    }
}

struct InfoCard: View {
    let title: String
    let detail: String
    let icon: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(.cyan)

            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct FloatingMenu: View {
    let close: () -> Void
    @State private var position = CGSize.zero
    @State private var isExpanded = true
    @State private var demoEnabled = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "circle.grid.2x2.fill")
                Text("DEMO MENU")
                    .font(.headline)
                Spacer()
                Button(action: close) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title3)
                }
            }
            .foregroundStyle(.white)
            .padding()

            if isExpanded {
                Divider().overlay(.white.opacity(0.2))

                Toggle("Demo switch", isOn: $demoEnabled)
                    .padding()

                Button {
                    isExpanded.toggle()
                } label: {
                    Label("Thu gọn", systemImage: "chevron.up")
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.bottom)
            } else {
                Button("Mở rộng") {
                    isExpanded.toggle()
                }
                .padding()
            }
        }
        .background(Color(red: 0.12, green: 0.14, blue: 0.23))
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .overlay {
            RoundedRectangle(cornerRadius: 18)
                .stroke(.cyan.opacity(0.7), lineWidth: 1)
        }
        .frame(width: 270)
        .shadow(radius: 20)
        .offset(position)
        .gesture(
            DragGesture()
                .onChanged { value in
                    position = value.translation
                }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity,
               alignment: .center)
    }
}
SWIFT

if ! command -v xcodegen >/dev/null 2>&1; then
    echo "ERROR: xcodegen is not installed."
    exit 1
fi

xcodegen generate -s project.yml

test -f IOSModMenuLab.xcodeproj/project.pbxproj
echo "=== Project generated successfully ==="
SWIFT
