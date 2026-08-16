import SwiftUI

struct StarterTask: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var category: String
    var isDone: Bool
}

struct ContentView: View {
    @State private var tasks: [StarterTask] = [
        StarterTask(title: "Explore the dashboard", category: "Setup", isDone: true),
        StarterTask(title: "Tap a quick action", category: "Test", isDone: false),
        StarterTask(title: "Mark a task complete", category: "Build", isDone: false)
    ]
    @State private var newTaskTitle = ""
    @State private var selectedTab = 0

    private var completedCount: Int {
        tasks.filter(\.isDone).count
    }

    private var progress: Double {
        guard !tasks.isEmpty else { return 0 }
        return Double(completedCount) / Double(tasks.count)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        heroSection
                        progressSection
                        quickActionsSection
                        checklistPreviewSection
                    }
                    .padding(20)
                }
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Starter")
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }
            .tag(0)

            NavigationStack {
                checklistSection
                    .navigationTitle("Checklist")
            }
            .tabItem {
                Label("Tasks", systemImage: "checklist")
            }
            .tag(1)

            NavigationStack {
                settingsSection
                    .navigationTitle("Settings")
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
            .tag(2)
        }
        .preferredColorScheme(.dark)
        .background(Color.black.ignoresSafeArea())
    }

    private var heroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("SwiftCode Starter")
                .font(.largeTitle.bold())

            Text("A small SwiftUI app with tabs, state, buttons, lists, and forms so you can test builds and simulator interactions.")
                .font(.body)
                .foregroundStyle(.secondary)

            Button {
                addTask(named: "Test simulator tap")
            } label: {
                Label("Add Test Task", systemImage: "plus.circle.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color.blue, Color.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .foregroundStyle(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.headline)

                Spacer()

                Text("\(completedCount)/\(tasks.count)")
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: progress)
                .tint(.green)

            Text(progress == 1 ? "Everything is complete." : "Complete tasks to update this progress bar.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .background(Color(.secondarySystemGroupedBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var quickActionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                QuickActionButton(title: "Add", icon: "plus", tint: .blue) {
                    addTask(named: "New starter task")
                }

                QuickActionButton(title: "Complete", icon: "checkmark", tint: .green) {
                    completeNextTask()
                }

                QuickActionButton(title: "Reset", icon: "arrow.counterclockwise", tint: .orange) {
                    resetTasks()
                }

                QuickActionButton(title: "Tasks", icon: "list.bullet", tint: .purple) {
                    selectedTab = 1
                }
            }
        }
    }

    private var checklistPreviewSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Next Up")
                    .font(.headline)

                Spacer()

                Button("View All") {
                    selectedTab = 1
                }
            }

            ForEach(tasks.prefix(3)) { task in
                TaskRow(task: task) {
                    toggleTask(task)
                }
            }
        }
    }

    private var checklistSection: some View {
        List {
            Section("Add Task") {
                HStack {
                    TextField("Task title", text: $newTaskTitle)
                        .textInputAutocapitalization(.sentences)

                    Button {
                        addTask(named: newTaskTitle)
                        newTaskTitle = ""
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section("Starter Tasks") {
                ForEach(tasks) { task in
                    TaskRow(task: task) {
                        toggleTask(task)
                    }
                }
                .onDelete(perform: deleteTasks)
            }
        }
    }

    private var settingsSection: some View {
        Form {
            Section("App State") {
                LabeledContent("Completed", value: "\(completedCount)")
                LabeledContent("Total Tasks", value: "\(tasks.count)")
                LabeledContent("Progress", value: "\(Int(progress * 100))%")
            }

            Section("Test Controls") {
                Button {
                    addTask(named: "Generated task \(tasks.count + 1)")
                } label: {
                    Label("Generate Task", systemImage: "sparkles")
                }

                Button(role: .destructive) {
                    resetTasks()
                } label: {
                    Label("Reset Demo Data", systemImage: "trash")
                }
            }
        }
    }

    private func addTask(named title: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedTitle.isEmpty else { return }
        tasks.append(StarterTask(title: trimmedTitle, category: "Demo", isDone: false))
    }

    private func toggleTask(_ task: StarterTask) {
        guard let index = tasks.firstIndex(of: task) else { return }
        tasks[index].isDone.toggle()
    }

    private func completeNextTask() {
        guard let index = tasks.firstIndex(where: { !$0.isDone }) else { return }
        tasks[index].isDone = true
    }

    private func deleteTasks(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }

    private func resetTasks() {
        tasks = [
            StarterTask(title: "Explore the dashboard", category: "Setup", isDone: true),
            StarterTask(title: "Tap a quick action", category: "Test", isDone: false),
            StarterTask(title: "Mark a task complete", category: "Build", isDone: false)
        ]
    }
}

private struct TaskRow: View {
    let task: StarterTask
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack(spacing: 12) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(task.isDone ? .green : .secondary)

                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title)
                        .font(.body.weight(.medium))
                        .strikethrough(task.isDone)
                        .foregroundStyle(.primary)

                    Text(task.category)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

private struct QuickActionButton: View {
    let title: String
    let icon: String
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2.bold())

                Text(title)
                    .font(.subheadline.weight(.semibold))
            }
            .frame(maxWidth: .infinity, minHeight: 88)
            .background(tint.opacity(0.14))
            .foregroundStyle(tint)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ContentView()
}
