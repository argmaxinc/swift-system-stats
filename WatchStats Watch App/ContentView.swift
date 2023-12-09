//
//  ContentView.swift
//  WatchStats Watch App
//
//  Created by Zach Nagengast on 12/8/23.
//

import SwiftUI

struct ContentView: View {
    @State var output: (free: UInt64, active: UInt64, inactive: UInt64, wired: UInt64, compressed: UInt64, totalUsed: UInt64, totalPhysical: UInt64, totalAvailable: UInt64) = (0, 0, 0, 0, 0, 0, 0, 0)
    let timer = Timer.publish(every: 1.00001, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {

            Section(header:
                        HStack {
                Image(systemName: "memorychip")
                    .imageScale(.large)
                    .foregroundStyle(.tint)}
            ) {
                HStack {
                    Text("Free")
                    Spacer()
                    Text(formattedBytes(output.free))
                }
                HStack {
                    Text("Active")
                    Spacer()
                    Text(formattedBytes(output.active))
                }
                HStack {
                    Text("Inactive")
                    Spacer()
                    Text(formattedBytes(output.inactive))
                }
                HStack {
                    Text("Wired")
                    Spacer()
                    Text(formattedBytes(output.wired))
                }
                HStack {
                    Text("Compressed")
                    Spacer()
                    Text(formattedBytes(output.compressed))
                }
                HStack {
                    Text("Total Used")
                    Spacer()
                    Text(formattedBytes(output.totalUsed))
                }

                HStack {
                    Text("Total Physical")
                    Spacer()
                    Text(formattedBytes(output.totalPhysical))
                }

                HStack {
                    Text("Available to App")
                    Spacer()
                    Text(formattedBytes(output.totalAvailable))
                }
            }
        }
        .padding()
        .onAppear {
            output = getMemoryInfo()
        }
        .onReceive(timer) { _ in
            output = getMemoryInfo()
        }
    }

    private func formattedBytes(_ bytes: UInt64) -> String {
        let bytes = Double(bytes)
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB]
        formatter.countStyle = .memory
        formatter.includesUnit = true
        formatter.isAdaptive = true
        formatter.zeroPadsFractionDigits = true

        return formatter.string(fromByteCount: Int64(bytes))
    }


}

func getMemoryInfo() -> (free: UInt64, active: UInt64, inactive: UInt64, wired: UInt64, compressed: UInt64, totalUsed: UInt64, totalPhysical: UInt64, totalAvailable: UInt64) {
    let processInfo = ProcessInfo.processInfo
    let totalPhysicalMemory = processInfo.physicalMemory

    let availableBytes = UInt64(os_proc_available_memory())

    var host_size = mach_msg_type_number_t(MemoryLayout<vm_statistics64_data_t>.size / MemoryLayout<integer_t>.stride)
    var host_info = vm_statistics64_data_t()
    let result = withUnsafeMutablePointer(to: &host_info) {
        $0.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
            host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &host_size)
        }
    }

    if result == KERN_SUCCESS {
        let pageSize = vm_kernel_page_size

        // Calculate the basic memory statistics
        let free = UInt64(host_info.free_count) * UInt64(pageSize)
        let active = UInt64(host_info.active_count) * UInt64(pageSize)
        let inactive = UInt64(host_info.inactive_count) * UInt64(pageSize)
        let wired = UInt64(host_info.wire_count) * UInt64(pageSize)
        let compressed = UInt64(host_info.compressor_page_count) * UInt64(pageSize)
        let totalUsed = active + inactive + wired + compressed

        return (free, active, inactive, wired, compressed, totalUsed, totalPhysicalMemory, availableBytes)
    } else {
        return (0, 0, 0, 0, 0, 0, 0, 0)
    }
}

#Preview {
    ContentView()
}
