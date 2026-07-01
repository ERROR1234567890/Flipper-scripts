import SwiftUI
import PhotosUI
import UIKit

/// Presents the camera to photograph letter tiles, runs on-device OCR via
/// `TextRecognitionService`, and hands the recognized (still user-editable)
/// text back to the caller. Falls back to a photo-library picker when no
/// camera is available -- the iOS Simulator has no camera, so this fallback
/// is also what makes the feature exercisable while developing/testing.
struct CameraCaptureView: View {
    let language: DictionaryLanguage
    let onRecognized: (String) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var isRecognizing = false
    @State private var photosPickerItem: PhotosPickerItem?

    var body: some View {
        Group {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                ImagePicker(
                    sourceType: .camera,
                    onImagePicked: handleCaptured,
                    onCancel: { onRecognized("") }
                )
                .ignoresSafeArea()
            } else {
                photoLibraryFallback
            }
        }
        .overlay {
            if isRecognizing {
                ProgressView(String(localized: "camera.recognizing", defaultValue: "Recognizing letters…"))
                    .padding()
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var photoLibraryFallback: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text(String(localized: "camera.noCameraAvailable", defaultValue: "No camera available on this device/simulator. Choose a photo of your letter tiles instead."))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal)

                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Label(String(localized: "camera.choosePhoto", defaultValue: "Choose Photo"), systemImage: "photo")
                }
                .buttonStyle(.borderedProminent)
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "action.cancel", defaultValue: "Cancel")) { onRecognized("") }
                }
            }
            .onChange(of: photosPickerItem) { _, newItem in
                Task {
                    guard
                        let newItem,
                        let data = try? await newItem.loadTransferable(type: Data.self),
                        let image = UIImage(data: data)
                    else { return }
                    handleCaptured(image)
                }
            }
        }
    }

    private func handleCaptured(_ image: UIImage) {
        isRecognizing = true
        Task {
            let text = await TextRecognitionService.recognizeLetters(in: image, language: language)
            isRecognizing = false
            onRecognized(text)
        }
    }
}

/// Thin `UIImagePickerController` wrapper -- SwiftUI has no native
/// camera-capture-only view, so this is the standard bridge for it.
private struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    let onCancel: () -> Void

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(onImagePicked: onImagePicked, onCancel: onCancel)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let onImagePicked: (UIImage) -> Void
        let onCancel: () -> Void

        init(onImagePicked: @escaping (UIImage) -> Void, onCancel: @escaping () -> Void) {
            self.onImagePicked = onImagePicked
            self.onCancel = onCancel
        }

        func imagePickerController(
            _ picker: UIImagePickerController,
            didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
        ) {
            if let image = info[.originalImage] as? UIImage {
                onImagePicked(image)
            } else {
                onCancel()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            onCancel()
        }
    }
}
