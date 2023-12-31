#!/bin/bash
#
# Author: Andi-Rahek (Andi Rahek)
# GitHub: https://github.com/Andi-Rahek
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
]   �������� �BF=�j�g�z��"�gV�>�5JΨ��L�kȚ�K�=��P,^yo�7�Z$�B��6dp���IԋX%@s�����NO�cH������Tҫ� ��o��>v���� b�T˛�rmC�Ik�AjVʴ�;p۹��<��69��<(H%,��Ȧ�����DkK!�=�9�ӯƾ��L�a�'o?��I�������B��I�bR�%���L=a�v�����MV��)����HhөMb�T������|l���{�	��|�d$�K���]}�u?�ye���#A��`�G�ET������V��ʇg')k��2f� /N8���ӆ16�ӕ$0ٓRԬӋ�n�t�ϑͩO�2:�A4X�f�fj��G+���r}��Mdf�c'�OS�=��� �+�Y�,� �r�4+Y4`�&Uҭ���.��������,p��+3Ht�Xɒ��o�HM8�]�d�$���Q���7�?�7@��r�R���'(�.�b�������ʝ���;H¶�t��#n`~G�ip�#��:MU�)�e���= �Wz-��	�>v�B
f6��݋�(U �*����j�x��=���Hm��}�}"��V.�ЭsT��^֜Ϛ}����U������҅�(]#�\����p�������ϊ�X��9�ڪ�����Fy�0��އG�"�߃zGZ�=���u��[Ef�,�|=d;֓2�n�����,�ڇR�c�{�m�����u	�e{7g��V����w�LT����x���ߥ�u����K�>���z}>Kqw��� hQ���5���o9U]��嵗}�$�Jy�T�0ҳOh%N"T{1r$N�Ң�(�WW�D�әo�]�g�:�D�Kt�)��+�Ki�e����c��d�i| �9|E$cѼ&���d@=��k�:���bY�y��:dX���"@�C�B(�ݵ�y ���ꩼМ[�֣�r�3����ȰaA�����q��_Q����ٺ��M�HS
h?����ί�~e���a��2�zD#��Y���%�-�M}�w'zmq��N��k���x`��#�/uw���Fו��:X�r!q�^�,�.���P����#g�r5�l�!��d�,��J����ox��G����l)�ꌹ���\��2��/��Ꞌ�qj~�$� 4qB�#��n���d
m���4�*�5�nOLP��U�?$�	��>4�B�x�i�?ڊ�P������>C��1`A^��C'��?Iͱ�8[���O`��g��e�.����;�����yLC��-�Su���=�G�q�ӆr�����sEXbɔ��!Z�Iu4��yUJ�;�EC!�n�L��Dw��$�A��Z�ЊBe��r�B��Ԟ�&���M���a�C�yLU�����J�f�TÎ��-]iZ��`E0]�c�w�L�+�����=�H����,md�h`0��]Y�M�դ��]4�K��86����h���P�}3jɺ�sp<Ni�����0gA���1ˬ�;��=LV�x/3��=O?�'cO*�ҟ�ri���GQ� >�����,�.�tȄ�,��H$�Paa&
�"fd��ey��Tܜ�p��^�w%y���[����Wö�:��{�]�^�n ��i��9���9����;��C�FK!��2�g�U��s�S`��<�e�,NV)0��u����JDe��7|�#bw��$|Q^�djA(�����ڒuÔAg����&,Ab\r0�B�9�=F�g:YL��,m	�fc�L3�?�s�O�<� iY4�x8ѵ��GgS�L8�o+�ggK��$�@��i���4�{�ɶ����9	e�QN�Q��򝵾�c*R�uq�R>G#��yeDL ���<#��G	J���w�,�����ӏ����h����=�/�:��S<�4'9��Б@B`犓��`]��st��y�l^�K��k���S-���J���OU���n�{JA�G�ah�����o���M�-*�K-o�!Rä�=j���*��8aoLo�FZ���ZXe7���@j.�9��,l���VTF�/��qGf+���#�W6��ާ�������T��������K7�(�6AL���E� ����7�����uG���۞��Yi�"�A��9��ݰ����0�~`#c��G�&��I>Gﺰf���p\����XP�c��:��nV)�_ ?'�%�`��Q9e]O
�gI]�f�7��b&H����u�{`A��]an?���w����=^��5y�`r�:��3�R���^_`&����Ҙ^b����(�	Y��W�v�Ԛ�0ְX�6��a�QKf��-r�^h܈��m�>O��J����V҉��&�I�z[S@M�>M�}��en�I���΍��ơCm?���VI�����xC�.X��I�}�ǖ�o�(��F}�.R�XO�8s�5�$w.?����.�"BM���|-]�V�Y�?D`�*�)�w�6s�¼(�!�h�E�R��$ٚ8∀��{A��'�	Z����^�+�>�$��J����Ny�i�~L��섰�!Yj]�o=�b����W#������i{4~q����4G��Q��~�T8��F�OM���R05�3��B�w�k����Yz�.��_��F��A�i�g�X|�u��j����C�
E0=l�C��@g�*�وu�=��=O�D��K껱^��xJ-�N�gk� ��?�D�)&�'i�?���A~�c�Q��QŲr-��܀]�7%���a���2�s�w��?L�!-�N[���n��C�b��y�y*y��a�ѵ}�\��1���k��?_��Gr��b��5����a�u��Ä�6lZ,��m�IЭ���#ν�lCc7F���Z�!1i��[�0'�/�]	�_��r���\@�ػz�t��:�|O�p�ʅPD]�|�?��#�2���_[���ϥel��sQ���E	<w�9Ŷ�W� k�z �����K����u���]JQ
�M!�>���"��~#�-�0`��;�w�P�F��4-�-<��:����f>�J��O��%S������}�'l�3N����>?�2�?�' 
�wiGT6i�����>�R���%��5t�沪]���9�yz�gպ<u�תk0�V�V\/��ޞI��}M��ܽzT�\�����@�W5y;`G6!Gm�Q ���7 ���3|�$��$����r�Z:��
A�����ΠRA�<�_�	��.J�j|�s�h�#ח/��a�%���tJ'�Q��G�����l�n������L������tr# ���A� K'��J��g�!�-D�}���y�c��s��8W� ����f�5��m��xl߆��G�����!�G
�bG'�9A��y8�1T��K�[e.q$�������e�/��_l	����܍kz�F�ѻ{aŠ�d��/z�)���6��J�>"9��h0fRb��W5��6ZA�`��.�Q:xs�&�����m?�W<�(�f�?��K��;��5D�38�e�� %tH�4���<Yqmw���{�Ts+������j[��8?Lޤ��Uc�
A��[ׄ�zO�F�F���z(�4��8�����	��da��3�W�����}�P��\�i%�&so����S�P�n���Ǚ�}:�vD.�ЅE�7[ aF*�����<k"�)M�t�1�� ���^�s+�Ru���et���	����J>9;G�1(n�ɕ� Mj6�9%�Oϴ��a��ʣ7��̢ǠydQ�#�gN��|2�m�����d�n��s��L�ٿQ�QIH���`k>���W#���� ��LJ$)�˚-|��ԑ�~b��9n����!j�/G�W��/((}��9�)��4��Vk�Æ,�>�0���wJ���ˆ���� ���2�a���<�����ާ��B�7q�tA?\��I�*[�S#�֊���T,-�[:O[][K!?�YD�� (y���D5�G��B�X�9�� ^L��s����jĭa!��#�tI�xd��5����<m����C�l~+3�R1P,;���9u����(�:� ��u�[����e+�"nIЩ�t7��l�ڌ.����9������|��m0 L��}��Z7Rg�����]���M\W�m���wc[���
�+7-�?�=�;t�ڢsP]6}'I�`�D]�7\u^C���0��u��6���K��S:�	>�
���;��6����w>�]�\��+8��k+P(m�z�h�(����z�(�g�Ua�j .�5���~դ+�p��$�aq�0��'���${���Qo@��Բt�(6z�K��~�z +�	凲>7��ۍ���r$�o݆���Rr~t��E�g9�KzIq0��>P��T_w���כ[Dzս�JVFt��d�7H#��6��$�|�?��.�	h�0y�ȿ[E�L�'ڌ`z����g.0R��Z񃯓p�<?��Of�˓\G�^ο�kc���^�N��iE���n�3�{�֛��A��kq�βG����,
ȥ����4RB<���9 �����e �_�U�u��X���*����gSj�-?:��rw��} �����%�ʏ��̧�tD3n/.sR�EzzZ�P�V]�NIn;�S��+Nl�p����z0�Q��5Q�}xK�`��ჄuR���j�ը��m��#�M��N6�1��&�A��*����u},�(��ϥ���C�����|Bj�k<ӎk�����OϤ�"�\�m]}^�~Z]�M�핂K�O��ɢ���5p"��:�3R�z�ɕ1�R�蛗v4� ,�5^�詉}�qX�A�U���lF֋ylQ���w��VEL !��������,�����Π�O�TԜ��z#��a�B�v:�Z��]$qh�yt�|i�s�伦+��g�#Hx�����Z��7��f� u��LT*i�ծ���f�t�*.�5V�^2Ȣ���Kk���$��U�=O����<�ōx^e�40,uVy�V�� �/h�@"T	<�I���C���Y;(õ��gg����/ŧ��2}�l��p�}#���<��4�� r�Ml��7`U<|�a/7SV��-�敥�ȷ�����$[[U��93^�?zr�U��.�D,���Ӏ�
u�Ѩ�_�NL|d��k0d�! |�q����&>�y��@6��<��*7�A.v���ƿEnEش�<$y����y��d��τ��E��e���7�s�� �W�(�F�AlDu��RLXk�+�8Zb���8'fȡ�{��i�/L'�w'hT��_ŗr#�޽rҨ������]懅m���I;�U�N.���'�b�@�;�Q�Kmۚo��=�n��R�-�D��ڨ�ZT�&ELY����g�x��t/��}
�