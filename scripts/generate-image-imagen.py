#!/usr/bin/env python3
"""
Imagen 3 Image Generation Script
Generates images using Google's Imagen 3 via Vertex AI
"""

import argparse
import base64
import os
import sys
from datetime import datetime
from pathlib import Path

try:
    from google.cloud import aiplatform
    from vertexai.preview.vision_models import ImageGenerationModel
except ImportError:
    print("Error: Required packages not installed")
    print("Install with: pip install google-cloud-aiplatform")
    sys.exit(1)


def generate_image(
    prompt: str,
    output_path: str = None,
    project_id: str = None,
    location: str = "us-central1",
    negative_prompt: str = None,
    number_of_images: int = 1,
    aspect_ratio: str = "1:1",  # 1:1, 9:16, 16:9, 4:3, 3:4
    guidance_scale: float = None,
    seed: int = None,
):
    """
    Generate image using Imagen 3

    Args:
        prompt: Text description of image to generate
        output_path: Where to save image (default: ~/projects/terminal-work/assets/)
        project_id: Google Cloud project ID (from env or param)
        location: GCP region (default: us-central1)
        negative_prompt: Things to avoid in image
        number_of_images: How many images to generate (1-4)
        aspect_ratio: Image dimensions (1:1, 9:16, 16:9, 4:3, 3:4)
        guidance_scale: How closely to follow prompt (1-20, default 13)
        seed: Random seed for reproducibility
    """

    # Get project ID
    if not project_id:
        project_id = os.environ.get("GOOGLE_CLOUD_PROJECT")
        if not project_id:
            print("Error: Project ID required")
            print("Set GOOGLE_CLOUD_PROJECT environment variable or pass --project-id")
            sys.exit(1)

    # Initialize Vertex AI
    aiplatform.init(project=project_id, location=location)

    # Load Imagen 3 model
    print(f"🎨 Loading Imagen 3 model...")
    model = ImageGenerationModel.from_pretrained("imagen-3.0-generate-001")

    # Prepare generation parameters
    params = {
        "prompt": prompt,
        "number_of_images": number_of_images,
        "aspect_ratio": aspect_ratio,
    }

    if negative_prompt:
        params["negative_prompt"] = negative_prompt
    if guidance_scale:
        params["guidance_scale"] = guidance_scale
    if seed is not None:
        params["seed"] = seed

    print(f"✨ Generating {number_of_images} image(s)...")
    print(f"📝 Prompt: {prompt}")

    # Generate images
    response = model.generate_images(**params)

    # Determine output directory
    if output_path:
        output_dir = Path(output_path).parent
    else:
        output_dir = Path.home() / "projects" / "terminal-work" / "assets" / "generated"
        output_dir.mkdir(parents=True, exist_ok=True)

    # Save images
    saved_files = []
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    for i, image in enumerate(response.images):
        if output_path and number_of_images == 1:
            filename = output_path
        else:
            # Generate filename from prompt
            safe_prompt = "".join(c if c.isalnum() else "_" for c in prompt[:30])
            filename = output_dir / f"imagen_{safe_prompt}_{timestamp}_{i+1}.png"

        # Save image
        image._pil_image.save(filename)
        saved_files.append(filename)
        print(f"✅ Saved: {filename}")

    return saved_files


def main():
    parser = argparse.ArgumentParser(
        description="Generate images using Google Imagen 3",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Basic generation
  %(prog)s "A terminal workspace with AI assistants"

  # Custom output path
  %(prog)s "Futuristic terminal UI" -o ~/screenshots/terminal.png

  # Multiple images with aspect ratio
  %(prog)s "Abstract tech pattern" -n 4 --aspect-ratio 16:9

  # With negative prompt
  %(prog)s "Modern office" --negative "cluttered, messy, dark"

  # Reproducible with seed
  %(prog)s "Geometric pattern" --seed 42
        """
    )

    parser.add_argument("prompt", help="Text description of image to generate")
    parser.add_argument("-o", "--output", help="Output file path")
    parser.add_argument("-p", "--project-id", help="Google Cloud project ID")
    parser.add_argument("-l", "--location", default="us-central1", help="GCP region")
    parser.add_argument("-n", "--number", type=int, default=1, choices=range(1, 5),
                        help="Number of images to generate (1-4)")
    parser.add_argument("--aspect-ratio", default="1:1",
                        choices=["1:1", "9:16", "16:9", "4:3", "3:4"],
                        help="Image aspect ratio")
    parser.add_argument("--negative", help="Negative prompt (what to avoid)")
    parser.add_argument("--guidance", type=float, help="Guidance scale (1-20, default 13)")
    parser.add_argument("--seed", type=int, help="Random seed for reproducibility")

    args = parser.parse_args()

    try:
        saved_files = generate_image(
            prompt=args.prompt,
            output_path=args.output,
            project_id=args.project_id,
            location=args.location,
            negative_prompt=args.negative,
            number_of_images=args.number,
            aspect_ratio=args.aspect_ratio,
            guidance_scale=args.guidance,
            seed=args.seed,
        )

        print(f"\n🎉 Successfully generated {len(saved_files)} image(s)!")

    except Exception as e:
        print(f"❌ Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
