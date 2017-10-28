#!/bin/bash
cd ../www && \
aws s3 sync --storage-class REDUCED_REDUNDANCY --acl public-read . s3://stuart.life
