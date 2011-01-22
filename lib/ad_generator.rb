require 'RMagick';

# A class that generates a single image out of an of image paths in an X by Y fashion
# The class is mainly meant to be extended and built upon to create unique 'ads' that
# consist of a compilation of different thumbnails
# For examples and usage, see the 'examples' folder

class AdGenerator
    private
    # Checks to see if there's enough images to generate an image of the
    # requested size. If not, it prints an error message to the screen and
    # returns false
    # * rows (integer): The number of 'rows' the image should have
    # * cols (integer): The number of 'columns' the image should have
    def enough_images?(rows, cols)
        total_images = rows * cols;
        if total_images > @images.size then
            puts "Not enough images to produce a #{rows} x #{cols} image.
              rows x columns cannot exceed #{@images.size}. Requested size requires
              #{rows * cols} images";
            return false;
        else
            return true;
        end
    end
    public
    # Class constructor
    # images (array): Array of image paths that will be used to generate the final image
    def initialize(images)
        @images = images;
    end
    # Generates the final image
    # * rows (integer): How many images across the final image should contain
    # * cols (integer): How many images down the final image should contain
    # * [save_path] (string): Where the final image should be saved to (optional). If no path
    #   is passed in, the function returns the image as an Image object
    def generate_ad(rows, cols, save_path = nil)
        if(enough_images?(rows, cols)) then
            images = @images;
            # Create ImageList representing the image we're trying to create
            ad = Magick::ImageList.new;
            1.upto(rows) do
                # Create new ImageList for each row requested
                image_list = Magick::ImageList.new;
                1.upto(cols) do
                    # Open the first image on the array of images passed in
                    # Remove the image
                    image = Magick::Image.read(images.shift()).first
                    # Add the image to the ImageList representing the row
                    image_list.push(image);
                end
                # Compile the row ImageList into a single image
                # and the append that image to the image we're trying
                # to create
                ad.push(image_list.append(false));
            end
            if save_path.nil? then
                # No save path, so just return the final composite image
                return ad.append(true);
            else
                # Compile the image and save it to disk
                ad.append(true).write(save_path);
            end
        end
    end
end