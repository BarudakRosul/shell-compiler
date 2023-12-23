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
U��Û��+A�Į�ܕ�7U���}��:��'i���&W�!�Љ0?��k�}�?��1Z~@�<�r�}�L�2,1��bdK�V�e��7��Bpx�r1L:{���ˑ��ύ��C�8u�Uo���v� x���[b��8lcl9���0).�mݑ���
�T�x>�`��l��N�Y]�?�Sr�F�o��_47#h��r��c�󶍉*�xS��S���h5ѕo|.KP#���Pi�;��}�0yݰ~�=���#kaFӨ�Lsn��G�[���'1�2�"���)|[K�=����iF��Y	��"(%m#�f)Cx�d�u��#�o�Y��}Q�
�H�&��-���c��lL�K~��]$3�#p��ˡU����6� �Ƒ��4d(�Z3��kg��b�g���z4<���4ħ9�h��V~�zj����K�����j*�4�*Ė�(�i��De9�6����G�����kC������mVˈ�BS_�z8گ������j�!n��s�H��p�?��[��8�N>�Y�v0���X�Q��p�k�𜗊b���:�7��"����c����W,�T�B�I��'	1[p̵G��O���t��A4v߲� ]�v�V�c�0'i,O>��Vy��vkه�@_�����.�|ҳ�t�NW�E[��-8�x�1~Έ �� [m� �V�K�SG=��XZ�e��_l ��Z�yǙ.����*�\�.l'{ϥ0���4�R���S��J-��QbB���s��NǢ�Ę��O�zNɛ���uQ*-V2�{�� ��������V�FXU�w��+_q���0���7��A�s����R��5I�$JP[��N�pfS�M86�
��z�y�.����F��E�`V`�}�eM@W���� 5*reuNȽ���������U��O�A�"U}��,�'?� �7���OHQ?�4�z���4�b����PjŌRQ�l D4�����s��h����0k��|C1�~\8M�5�3���!����w���ݓ��`�Crd���t
��~���跱˪O�����C<���l�ymqr)n>�1kK���b,�ى76|�-5H�
�7��L\8[�X�S��;.�WZ�ؤֲ���ֱ%@�����o�:UC��M����/~e;M멏���X��ܫ��a
�H��z�2�QUu�2 ��rhM.3�y�f�>����l$���q���A�i0�rWK8��C0U��UO���ܽA�U� �N�%���ì�op8ӕUޠ���;����<�w�U7��F�+ȤL�[���z�n�Un2�:��.�p��y��	\�35�Y�-�Z���<&��l�?�t��M�_r#����{���.�S�����ë���ՍDv���~B�`��� �{�f?��9u�]� h�Ģ̌&LA�@��_�2�[ɤ��B[>��F�!�������6&7�zWi�*E'\��K4�Z��T![��|D�t���"�k*�܎i�,�G7\�l_,S���#<�'N��
������ܰ��V�{��&�i�|��oEV�����5/T��k�/7���AT�I2�,���R����9Pc-�8�eâ�V�IШo��?��O�
��h-��5��z7֛�_�0�H��HߩS�n��K�p.�|\�J�ԅ{S*��s~�Db�02�B�tд̄ۖ��������%Drz�ao���#��3/���#F�Iȱ_�4�m��xso2�N|���@�����%�� ����D�*t~~ٝ�E��{<�j��;z�9����!I��t��}_^�o0�q8�@��:�"���]�&�������PP8+	a��d�驤n~�6'���XEο$w�'
�ׁÅ��}T���	�]zܧ�z��+��Ս��w�%tzlѶ*��+cO�Ų��T�T��`�@�-���#ێ��Y�#����T0Z�	��ט�sp��֋m�M�o�L�a,o���i�������ȱ���hhzw���ΰtl�\ߐD��
��w�	7F~lj3���0�w��OpF�y�%�zC'�:���7�����ѯ=޻p3:eN����d�zϜ9uy�W�d7�����̽�oDw���#Tg� �x˒l��Z6Z㍁3�2��m���ù��H
�8x�l����d��˺�d�^4�Gڇ��ZW�q�U�Jn�S�}xP�'�\S۷��`�R��8�:�i�G����u�PS�ܤ��4v^o�/zóíe�*��B��7b��DJ*����F�>՗���ڽ��<��@��3Zy�R�a�'r�(��>���d
!/�(AZ��w�	��YG����'J�7�����^�.ව����HK�b�"��r}�|o�MTC�3t��zi��귰/5fF�o��(�����"�ir����74^�}ô^����$�� Tb? ^�Hh�����V�9bT��8���x��"�8(|t+泲��$�r=H�	̤��`3�x�P���,���n��{_�p7��wyP�:�A7�LeͭQ������E��)���"-6+��h& �0�Wů�zye�LNp��1}��B*%�+�LI�GE�x��p�%{��~` g��Ԡ��e�Mix�=[,Q��f��u��Q5�3d��{R�F�����"ƝKUu4�^j>G�ު�q�;�)�v�.���/bW8���¢��э ��ޤ�@S��
��{g��1~�*K0ߞɊg���7�q?0e0�r� ���ef,>�F7X�v>:����vJ� �U�K��]���Y?� ���k�w]qn��~�0��.�`�kh���VT�f�`&h�VVkذw�B�B�or9\*�;���K��	�8�?S�t�~�Q'kt��������Vܺ��c�*�*��u1MS��m-�sV�U��2�)�u�>h<�"�zv���-b�����M00��D��W����uFI�=Y��U��:o���O�}*�U�U�#�BK?E{��(�:��Àڋn� �<�M�ή9owIy:�j�qg���(|��ۂǯB�����*��'�,W�j�+:������e����&'5���S��(�/o�9�l0�2��]6鯊�X@�1F��o�G�
?�x���*�mEuW�;Ԩ�FX�$���RV}Ƅ�W�K�|r(���g�)�m$/0�sB��轝�6$�QKj_���^BPh>{@*i��Fm��C�O��i���������FE�O�d�
۽;�B�H4�,&e �a`Vٓތ��nf"��+�	�r]?���[�iӣ�B-���-f*܈�3�q���S#�"�� �`V�t{����t�W�\������Hˮ��E��ёz�p��&ND�W��Ap�����>g�q�
����c�|�7����2o��r��@V9��Zo��	)�wlXM$����V�Y���n�Ɍ�Y�1L	A����j��h�?s�%��>}���#h�s�݌��y͸��7T3�1�ٮ&�<4�)�Q��e��=�i��2�AAh��1ƶ��.D9:�Ƀ����ޞ��<M�hf�W�~&�hj��vvH�=N�b�4m�m�Mh�1{��p���#3���kcN��s7~�J�My/������!����n�/}�s9O6��g�
�E�˩���?��T��,�e����x^�M�ٷ��2D�uRќ�1�;��&�����a��;�?��Q�^J���'/$bL��4�A[���vCp��`Jd�
���Ӏ���8e��itZ���+����-�s����ջf^%��[kL{�=h+�}J����p�����D���)�������k3R���c�'�����r�K�s
\�L��,��KG���f2m�&��8O�{}�Hd�m���	� �t�R�W�@�����]o�� ua��$�qZG�����s^�j�j��D��]<����NV�F���r��KW�3(�]��VS"�-��=/��j]�?�B+u�A�ڱ�>��"<� xKݒr�r�/Q@�I@H7Y��@LlK÷Ʌ{5��怒�Z�ɬ��2H�0�D@ƙ��g{�-�Q-��7�����