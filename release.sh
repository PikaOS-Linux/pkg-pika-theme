# Sign the packages
dpkg-sig --sign builder ./output/pika-*-meta*.deb
dpkg-sig --sign builder ./output/pika-package-manager*.deb

# Pull down existing ppa repo db files etc
rsync -azP --exclude '*.deb' ferreo@direct.pika-os.com:/srv/www/pikappa/ ./output/repo

# Remove our existing package from the repo
reprepro -V --basedir ./output/repo/ removefilter kinetic 'Package (% pika-*-meta*)'
reprepro -V --basedir ./output/repo/ removefilter kinetic 'Package (% pika-package-manager*)'

# Add the new package to the repo
reprepro -V --basedir ./output/repo/ includedeb kinetic ./output/pika-*-meta*.deb
reprepro -V --basedir ./output/repo/ includedeb kinetic ./output/pika-package-manager*.deb

# Push the updated ppa repo to the server
rsync -azP ./output/repo/ ferreo@direct.pika-os.com:/srv/www/pikappa/
