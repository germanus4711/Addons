10

It's a simple process.

A) Create a personal-access-token (PAT)

For that, go to github.com/YOUR_USERNAME
(note that the process doesn't work on gist.github.com/YOUR_USERNAME)
go to your profile (the rightmost icon), there click "settings".

In the left sidebar, click "Developer settings".
There, select "Personal Access tokens" => "Tokens (classic)" and click "generate new token (classic)"

In the dialog that opens, input something that identifies the token under notes, e.g. the hostname of your PC

For expiration, set to no expiration (or else have great fun resetting this every year, because you can't expire it after 5 years, only for periods shorter than 1 year or else you need unlimited...)

under selected scope, click the checkbox for "repos", then click "generate token".

This will then display your PAT token (use your eyes).

B) Add the token to your git-settings

Now, on the git command line, issue

git config --global credential.helper store
Then, you need to add the token:

git credential approve
<press Enter>
protocol=https
host=github.com
username=USERNAME
password=TOKEN_FROM_WEBSITE
<press Enter twice>
The token has now been added.
You can now perform

git clone https://github.com/...
