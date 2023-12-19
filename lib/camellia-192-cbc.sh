#!/bin/bash
#
# Author: RFHackers (Rafa Fazri)
# GitHub: https://github.com/RFHackers
#
# shell-compiler: compressor for Shell Unix executables.
# Use this only for binaries that you do not use frequently.
#
# I try invoking the compressed executable with the original name
# (for programs looking at their name).  We also try to retain the original
# file permissions on the compressed file.  For safety reasons, bzsh will
# not create setuid or setgid shell scripts.
#
# WARNING: the first line of this file must be either : or #!/bin/bash
# The : is required for some old versions of csh.
# On Ultrix, /bin/bash is too buggy, change the first line to: #!/bin/bash5
#
skip=77
set -e

tab='	'
nl='
'
IFS=" $tab$nl"

# Make sure important variables exist if not already defined
# $USER is defined by login(1) which is not always executed (e.g. containers)
# POSIX: https://pubs.opengroup.org/onlinepubs/009695299/utilities/id.html
USER=${USER:-$(id -u -n)}
# $HOME is defined at the time of login, but it could be unset. If it is unset,
# a tilde by itself (~) will not be expanded to the current user's home directory.
# POSIX: https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap08.html#tag_08_03
HOME="${HOME:-$(getent passwd $USER 2>/dev/null | cut -d: -f6)}"
# macOS does not have getent, but this works even if $HOME is unset
HOME="${HOME:-$(eval echo ~$USER)}"
umask=`umask`
umask 77

lztmpdir=
trap 'res=$?
  test -n "$lztmpdir" && rm -fr "$lztmpdir"
  (exit $res); exit $res
' 0 1 2 3 5 10 13 15

case $TMPDIR in
  / | */tmp/) test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  */tmp) TMPDIR=$TMPDIR/; test -d "$TMPDIR" && test -w "$TMPDIR" && test -x "$TMPDIR" || TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
  *:* | *) TMPDIR=$HOME/.cache/; test -d "$HOME/.cache" && test -w "$HOME/.cache" && test -x "$HOME/.cache" || mkdir "$HOME/.cache";;
esac
if type mktemp >/dev/null 2>&1; then
  lztmpdir=`mktemp -d "${TMPDIR}lztmpXXXXXXXXX"`
else
  lztmpdir=${TMPDIR}lztmp$$; mkdir $lztmpdir
fi || { (exit 127); exit 127; }

lztmp=$lztmpdir/$0
case $0 in
-* | */*'
') mkdir -p "$lztmp" && rm -r "$lztmp";;
*/*) lztmp=$lztmpdir/`basename "$0"`;;
esac || { (exit 127); exit 127; }

case `printf 'X\n' | tail -n +1 2>/dev/null` in
X) tail_n=-n;;
*) tail_n=;;
esac
if tail $tail_n +$skip <"$0" | lzma -cd > "$lztmp"; then
  umask $umask
  chmod 700 "$lztmp"
  (sleep 5; rm -fr "$lztmpdir") 2>/dev/null &
  "$lztmp" ${1+"$@"}; res=$?
else
  printf >&2 '%s\n' "Cannot decompress ${0##*/}"
  printf >&2 '%s\n' "Report bugs to <barudakrosul22garut@gmail.com>."
  (exit 127); res=127
fi; exit $res
]   �������� �BF=�j�g�z��"�gV�>�5I�����ޗ��!��3K�!be0}��]R�DDU�����m�]O����W���&<�/A�}��gV}�����&:W_}m�����(��X��,4�cb���Ȝ�g��ʥM�U���\���0��i��p'ǰ��������i2�.O��_��	`hQ�a�|���,
�A#71$�]	�б�'[���	%���^�e22пX4��۶��	wT�A��n�4�N˙�)ӱ�0�qx�fo' �xK�xM}(E�՘>6��WE��֣�[54�a�ҧ��0IR�R��Y�S��GOCZH]�����b�?�O�*�5P��!�ĸ�x�P,[|F�$�Kw��QL��2k����DLk� fv@b�QO�Q�b��(�BY��kQf����hɊ>��}:��Q`��S��_372��ְ�� /| K�VE�4����M��X�˜���;_��`����K�T��I�'��᳂��U@�P1O�8#7(��� �|a9�EXq������8J�v�J����xS�䎍�X�1
ڷ,j<R�|R͔5�����t-i�P�$\{�A77^�ܦW;��0R��iT���;r�J�eD%�K��΍m�{�����F��ཫ���>�Qu&jS[�	fD&��{ET�_�d��d_���BEm#�En���|�h���a�C�������Ba�K��L[uc�TP"Ij�1���V�q<��X�`?NN>e<>$�y�
@ �g�T���Q���5��JB��OҀs(�Nd��wy��i�{��a�jr4�z�!�u�<���`*��M{Jl���]7}%���9o`�@�)Zj�;� �#-��5-9X�([V�t��|�����!$\� Ɋ���E&F	�<v������!���]�3v�eN�����<r��ž��7�
�7�)8��ԧ�r�)*�L�a�/~�K��u���^⯽��v�;{ԂcEYB`_���@_Aj�~����f��k�f����ԭ=G��P��@���[�l�\�E�~�p����6�#s딊^bF*c����l��z�E���6��U�nJ���6����j�]r� ��4�}Ŏ&�]�ɞ��8�(,�mr#R@:�d%�,��gK7�b6��nO�E�x8j����Lb�㶷��P��Z��^��=�1��[*�M��\ʱW��i��2��N��@4x��C\O�!طT<�Q�{��`$:�^�K���~�������}�8�Qi1o
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Ў]���*y�#8{�D�B�ۙ�^�!�59���-%��N��`i��Sl.���[�~�k�MCU�����?<�R��-$����r�-�����VA�=!���D۝�c�=D��D�[<}mg�g��,v�/kEQ}dT� ���G�������Y��)�j%!mMLݛ*���,.�������{Zagٙ/O����y�'�]B�iY����
�*k[0J����o��q���^%�ˀk��;���A\w�xC��Gy��)9��EA��-�
�x	�&���|���R1��8E�ɎC���:�w�{7���g��/E�_���e�� �-.3�������*�,mr�P�'�Hp��]7!!�\VQ!V�2ު��s+(������&��ߊ����6�Iw0�->TԖ){$�s��3���ũ����q�M�e�&Z�j7��3]Xp��e������`\s�1��?b�\-M��y���W)"���#]��S�����e�k<�;!щ�������&o�b^J4���]��Gl]���;Zr�1t9�~��0�Z�<-���	�:�l��3������s��J�A�p�ڲ.P|9A~Ǿ{[g|�d�ӟȢn^�	�C���-����O�t�ڥӱc��>����+P�k�f�i�3�F��>aV�d1��,t���Q]?]=�:&q�a@y@4�Җ���(���1�f��ee��͛��I��,� LE7����X��~w'�)��>��V����T�z7�#��6��t]��[ [�B�� �s��N`���Ǭh"��*�=�B�˹��@�������S�ϒ�Ȟ%����gA�@�^z�y���^�3Oc��.zDZ�7��S+�A&"�R�@�(.f��3��B�Tg�Y�]�k��
e'�5wl::�b�S����/�Ͷ_�BD�ޣ@�m;/j}�5s�S|R�Q��֎rz���Ƣ�m��L>�9�=���O�^o��%E+/- u��d�x2U�c��ht0�<�5�w�n?�!&�T����b�$%�{���JEY�������t��)|��P*��N�D$��2t칈�<J��;(������de4��%�a���wP�o?��}��s��D�w�����������G�*Y1/.4�h6�/�B���c卧�#EN�(O>�Q�3a����8=_����4b~����v�^�ɦ��0��C�/�s����ǿ��G�k�wY�i��X��LT�� �Y|��QnUC{��#��:#�_4��O��:>�7!�3H 	��92P�����a��/����(�X�ԩ*��Ş����
)����q�=cJ��Z�7Y�8�kC�ܖ�s���u0brQߺ0�o_@��6;�)L�����zJ���^��m$�ڷⲢ������,2Hփ���R4N��CĘ�'>���A�wO��]��l[*��7��Rzw-�~>��v���T�pV���ȸ���vǏ��t�A�^�=	���`�G7�yH�.�˳<�F6�V��?������G)�z��Y��8:�R���@�"1^��z���,�r�Q���ĿS���rM^�W�kSMi�C]�j��DWa�šn/��:"χ������e����y�lVq���S,f���ЄT��p�K�#<�� vG5i���wk6�5�I�տr3�q��!}x����rJ�E
k�\�ė��{=QrֽR�n3I���4Jʎ��);�(/����V��+�4��9��)2�ٙY�Ǝ ��L�����Ԃ�.0N��t*t繍ddzH�4�r������{��5*Q�S����T>d�������(�y�T���-v��a2A�q؄�/tH�{�Fڦ)@k��i��FE�¶��,�Y���K��q�y{�|]U�ɠ�� �����^I��*cn�Ɛ���-�c	��gTY:����L:��н
nKңu9H�hr��W������#�‐j.�o㒰.����Un�>
���[���?&�W�",���*��*����Ly0o���r�=�&<x0|���jP���5�B�:�]��;vr��ݔkV��B��BS��VWzo�>����c�#|����7��e2n��Bq���J<�����Ж���˛H� f4�J/�%�Q��
��v<H#>u�/_��g˄�ǃ[/�p��TA���,�%C���|C��*��C�qM�Kl�!ZBmv�g�N;���$��b��c�pj��wL��x�����aȗ�QI��̫���9�F�����A������?�ų|���i������xj�KcÏ	�D4�5��#в�P��	��ASJj\/��lb�۩PP<t�w_9
��@Ba��=�	r��⛢�E)h,���&���AW�?^���Ft�ӵ]�g&�uޞtZ�<p�Y�䪷��h�G\q���Hq����(2��ɩ4�
_�ӕ{��0Dc�U�8nQ�%�	�V=N}���w)	E0���I�~��0�x��oQ�<����T=��A����ɑ�䗕rWU4 �~,q��c�4�K� ����T��+��pd�����h�\��Q_m5K��F�w�놾�XX8��g�s]d-î�@b�w��U�FYj�{��ԓ�n����)�N�.��ߵ�zӷ;����X����c�?Q@���i�=���d���U���7_�lU��|����ܒ����e�2�G�7ƝM^j��%ox�T-��	y}���)Q�y�tk|e��
ھat��|� �Pҍp�W$i!�G
�_t��Y���W�mT��LS�g���1�L�~�J��=@��饫L�?�p�C��,�p-܍��x�|m�f�촎5U����O�0m2Juk�K��"�1��Yc�F3������e��r�[o#ӭs�z��V���5�>0�^����T8 ������cv��V��>ɏ�a�40~`�<�GC�]����:u�<ԕ7�!�N�ܹbq�m�d�i�M"D���D�awIi�^R��-��z5L������8��sK<�p�Fu�v��T~����zt��V���XQr�?4����|j����k�=����E��7����������|�<�j3R���������ݦی/M�����ҝW�dW���j�5*�j=f��-AÌ�Մ�$���KA�����v���[��0]���[��Ls=E�U=��A-c^�#����U`��z��e���4��U5Ic����r�Q�Wؑ2f������0Fz_6���7 <O��`�h�&d�F�7�ZŜ|Sg�#�~ڿ� �'�JX�Q��G�	H���_|2�K��/0s�u�Y��q*�6j�H 3�y(8�^��C-i1m��/r׉v�f��	��!6Վ0/��y�{��=�6�p��� w���F(�ɇ���G�G�}>���V��ҧ��P�q���Ro?�oy����U�����HcGiÞ��_N�?�o����vY�&�/cg��`]Kw��6r����P���#��+�+U��ג֨�T=��&֦�M@�n	_-);>zi���TWd�������I���!��.�@3��&�$�E�"g�9d�'aP �0,-?��[w)�(����TS����T�1�[�U�yEa�"��[kr��wd�1K�b�AU��I����㹡��3��t'�I��
�p�g(�����G�V=sϪ���k���@1�o�DQl2�\��ZJ<��i��-n���C
)�wǅ��Jk��:�_ct&��G6�ʳ;jԿ0��G�=�R���=c)����w�����`{0�}�/�Ψ�<�+�/K�~Z�;�R���Jl�U�F�L��ag�<j�����#ߵPU��¯w�zH�JD/�/�hv�bX�QX���� �d�Pfډ��Sa�2�#q��[��@?W5�xU�[\=��b���B�(�_!�H��@w�7d0�t��	f�#.�{y�Ò_�4����V.߃��n�� }����[5\�z4	��c��K��=/����e��hˀ���%���Q�בr�]�.ۃEy4��v��[�&���o>�^�ȧZ�Ҋ��� ��k������a�eR���#*Q�]N�0��)���a�T�5
|��W���d�Г�<e�� �:�g"L^.�"1;hJ���>�7++Y�'ϘzK���D