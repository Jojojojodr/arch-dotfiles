FROM archlinux:latest

# Install basic dependencies
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm sudo git

USER root

RUN echo "root:root" | chpasswd

# Create a non-root user for testing
RUN useradd -m tester && echo "tester ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
RUN echo "tester:test" | chpasswd

USER tester
WORKDIR /home/tester

# Copy dotfiles into the container
COPY . /home/tester/dotfiles
WORKDIR /home/tester/dotfiles

# Set environment variables if needed
ENV HOME=/home/tester

CMD ["bash"]