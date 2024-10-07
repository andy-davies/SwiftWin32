import WinSDK
import Foundation

let hInstance: HINSTANCE = GetModuleHandleW(nil)
let className: [WCHAR] = Array("SwiftWindowClass".utf16)

var wc = WNDCLASSW()
wc.style = UINT(CS_HREDRAW | CS_VREDRAW)
wc.lpfnWndProc = { (hWnd, uMsg, wParam, lParam) -> LRESULT in
    switch uMsg {
    case UINT(WM_DESTROY):
        PostQuitMessage(0)
        return 0
    default:
        return DefWindowProcW(hWnd, uMsg, wParam, lParam)
    }
}
wc.cbClsExtra = 0
wc.cbWndExtra = 0
wc.hInstance = hInstance
//wc.hIcon = LoadIconW(nil, IDI_APPLICATION)
//wc.hCursor = LoadCursorW(nil, IDC_ARROW)
//wc.hbrBackground = HBRUSH(COLOR_WINDOW + 1)
wc.lpszMenuName = nil
wc.lpszClassName = className.withUnsafeBufferPointer { $0.baseAddress }

if RegisterClassW(&wc) == 0 {
    fatalError("Failed to register window class")
}

className.withUnsafeBufferPointer { classNamePtr in
    let windowTitle: [WCHAR] = "SwiftWin32".utf16.map { WCHAR($0) } + [0]
    windowTitle.withUnsafeBufferPointer { windowTitlePtr in
        let hWnd = CreateWindowExW(
            0,
            classNamePtr.baseAddress,
            windowTitlePtr.baseAddress,
            DWORD(WS_OVERLAPPEDWINDOW),
            CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
            nil, nil, hInstance, nil
        )
        
        if hWnd == nil {
            fatalError("Failed to create window")
        }

        ShowWindow(hWnd, SW_SHOW)
        UpdateWindow(hWnd)

        var msg = MSG()
        while GetMessageW(&msg, nil, 0, 0) == true {
            TranslateMessage(&msg)
            DispatchMessageW(&msg)
        }
    }
}